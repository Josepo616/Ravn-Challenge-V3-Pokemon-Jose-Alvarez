//
//  PokemonRepository.swift
//  Pokedex
//
//  Created by JoseAlvarez on 10/6/25.
//
import Foundation
import SwiftData

@MainActor
final class PokemonRepository {
    private let context: ModelContext
    private let jsonDecoder = JSONDecoder()
    private var fetchError: Error?

    init(context: ModelContext) {
        self.context = context
    }

    // MARK: - Public Methods

    func fetchAndStorePokemons(offset: Int = 0, limit: Int = 50) async throws
        -> [PokemonsEntity]
    {
        if let localPokemons = try fetchLocalPokemons(
            offset: offset,
            limit: limit
        ),
            localPokemons.count == limit
        {
            return localPokemons
        }

        let pokemonAPI = PokeApiService(
            endpoint: .pokemon,
            parameters: [
                .limit: "\(limit)",
                .offset: "\(offset)",
            ]
        )

        do {
            let response: PokedexResponse = try await getData(
                from: pokemonAPI.url.absoluteString,
                type: PokedexResponse.self
            )

            _ = try await processAndSavePokemons(from: response.results)

            try savePokedexMetadataIfNeeded(response: response)

            try context.save()

            return try fetchLocalPokemons(offset: offset, limit: limit) ?? []
        } catch {
            self.fetchError = error
            throw error
        }
    }

    func fetchPokedexMetadata() throws -> [PokedexEntity] {
        let descriptor = FetchDescriptor<PokedexEntity>()
        return try context.fetch(descriptor)
    }

    func fetchPokemon(by name: String) async throws -> PokemonsEntity? {
        if let localPokemon = try fetchLocalPokemon(by: name) {
            return localPokemon
        }

        let pokemonAPI = PokeApiService(endpoint: .pokemonByName(name))
        let pokemon = try await fetchAndCreatePokemon(
            urlString: pokemonAPI.url.absoluteString,
            name: name
        )

        context.insert(pokemon)
        try context.save()

        return pokemon
    }

    func getFetchError() -> Error? {
        return fetchError
    }

    
    func updateComponentProperty<T>(
        componentType: T.Type,
        propertyKey: WritableKeyPath<T, String?>,
        fetchURL: @escaping (T) -> String,
        fetchProperty: @escaping (String) async throws -> String
    ) async throws -> [T] where T: PersistentModel {
        let descriptor = FetchDescriptor<T>()
        let localComponents = try context.fetch(descriptor)
        let componentsToUpdate = localComponents.filter {
            $0[keyPath: propertyKey] == nil
        }

        for component in componentsToUpdate {
            var mutableComponent = component
            let url = fetchURL(mutableComponent)
            let propertyValue: String = try await fetchProperty(url)
            mutableComponent[keyPath: propertyKey] = propertyValue
        }

        try context.save()
        return try context.fetch(descriptor)
    }

    // MARK: - Private Helper Methods

    private func fetchLocalPokemons(offset: Int, limit: Int) throws
        -> [PokemonsEntity]?
    {
        let descriptor = FetchDescriptor<PokemonsEntity>(
            predicate: #Predicate { $0.id > offset && $0.id <= offset + limit }
        )
        let pokemons = try context.fetch(descriptor)
        return pokemons.isEmpty ? nil : pokemons.sorted { $0.id < $1.id }
    }

    private func fetchLocalPokemon(by name: String) throws -> PokemonsEntity? {
        var descriptor = FetchDescriptor<PokemonsEntity>(
            predicate: #Predicate { $0.name == name }
        )
        descriptor.fetchLimit = 1
        return try context.fetch(descriptor).first
    }

    private func processAndSavePokemons(from results: [Pokedex]) async throws
        -> [PokemonsEntity]
    {
        var newPokemons: [PokemonsEntity] = []

        for result in results {
            if let existingPokemon = try fetchLocalPokemon(byUrl: result.url) {
                context.delete(existingPokemon)
            }

            let pokemon = try await fetchAndCreatePokemon(
                urlString: result.url,
                name: result.name
            )
            context.insert(pokemon)
            newPokemons.append(pokemon)
        }

        return newPokemons
    }

    private func fetchLocalPokemon(byUrl url: String) throws -> PokemonsEntity?
    {
        let descriptor = FetchDescriptor<PokemonsEntity>(
            predicate: #Predicate { $0.url == url }
        )
        return try context.fetch(descriptor).first
    }

    private func fetchAndCreatePokemon(urlString: String, name: String)
        async throws -> PokemonsEntity
    {
        let (detail, species, evolution):
            (PokemonDetail, PokemonSpeciesDetail, EvolutionChainResponse) =
                try await fetchLinkedResources(
                    rootURL: urlString,
                    speciesURL: { $0.species.url },
                    evolutionURL: { $0.evolutionChain.url }
                )

        return createPokemonEntity(
            name: name,
            url: urlString,
            detail: detail,
            species: species,
            evolution: evolution
        )
    }

    private func createPokemonEntity(
        name: String,
        url: String,
        detail: PokemonDetail,
        species: PokemonSpeciesDetail,
        evolution: EvolutionChainResponse
    ) -> PokemonsEntity {
        let nextEvolutions = NextEvolution.getAll(
            from: evolution.chain,
            currentPokemonName: detail.name
        )

        return PokemonsEntity(
            name: name,
            url: url,
            id: detail.id,
            imageURL: detail.imageURL,
            imageShinyURL: detail.imageShinyURL,
            color: species.color.name,
            height: detail.height,
            weight: detail.weight,
            generation: species.generation.name,
            flavorText: species.englishFlavorText,
            evolutionTrigger: nextEvolutions.first?.triggerName,
            types: detail.types,
            nextEvolution: nextEvolutions
        )
    }

    private func savePokedexMetadataIfNeeded(response: PokedexResponse) throws {
        let existingPokedex = try context.fetchCount(
            FetchDescriptor<PokedexEntity>()
        )

        if existingPokedex == 0 {
            let pokedex = PokedexEntity(
                count: response.count,
                next: response.next,
                previous: response.previous ?? "nil"
            )
            context.insert(pokedex)
        }
    }

    func getData<T: Decodable>(from urlString: String, type: T.Type)
        async throws -> T
    {
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }

        let (data, response) = try await URLSession.shared.data(from: url)

        guard let httpResponse = response as? HTTPURLResponse,
            (200...299).contains(httpResponse.statusCode)
        else {
            throw URLError(.badServerResponse)
        }

        return try jsonDecoder.decode(T.self, from: data)
    }

    // MARK: - Linked Resource Fetch Helper

    private func fetchLinkedResources<
        T1: Decodable,
        T2: Decodable,
        T3: Decodable
    >(
        rootURL: String,
        speciesURL: (T1) -> String,
        evolutionURL: (T2) -> String
    ) async throws -> (T1, T2, T3) {
        let detail: T1 = try await getData(from: rootURL, type: T1.self)
        let species: T2 = try await getData(
            from: speciesURL(detail),
            type: T2.self
        )
        let evolution: T3 = try await getData(
            from: evolutionURL(species),
            type: T3.self
        )
        return (detail, species, evolution)
    }
}
