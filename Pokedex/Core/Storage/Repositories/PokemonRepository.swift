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

    init(context: ModelContext) {
        self.context = context
    }

    func fetchAndStorePokemons(offset: Int = 0, limit: Int = 50) async throws
        -> [PokemonsEntity]
    {
        let descriptor = FetchDescriptor<PokemonsEntity>(
            predicate: #Predicate { $0.id > offset && $0.id <= offset + limit }
        )

        let localPokemons = try context.fetch(descriptor)

        if localPokemons.count == limit {
            return localPokemons.sorted { $0.id < $1.id }
        }

        let pokemonAPI = PokeApiService(
            endpoint: .pokemon,
            parameter: ["limit": "\(limit)", "offset": "\(offset)"]
        )

        let response: PokedexResponse = try await getData(
            from: pokemonAPI.url.absoluteString,
            type: PokedexResponse.self
        )

        var newPokemons: [PokemonsEntity] = []

        for result in response.results {
            let pokemonDetail: PokemonDetail = try await getData(
                from: result.url,
                type: PokemonDetail.self
            )

            let speciesDetail: PokemonSpeciesDetail = try await getData(
                from: pokemonDetail.species.url,
                type: PokemonSpeciesDetail.self
            )

            let evolutionChain: EvolutionChainResponse = try await getData(
                from: speciesDetail.evolutionChain.url,
                type: EvolutionChainResponse.self
            )

            let newPokemon = PokemonsEntity(
                name: result.name,
                url: result.url,
                id: pokemonDetail.id,
                imageURL: pokemonDetail.imageURL,
                imageShinyURL: pokemonDetail.imageShinyURL,
                color: speciesDetail.color.name,
                generation: speciesDetail.generation.name,
                flavorText: speciesDetail.englishFlavorText,
                types: pokemonDetail.types,
                nextEvolution: NextEvolution.getAll(
                    from: evolutionChain.chain,
                    currentPokemonName: pokemonDetail.name
                )
            )

            context.insert(newPokemon)
            newPokemons.append(newPokemon)
        }

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

        try context.save()

        let allDescriptor = FetchDescriptor<PokemonsEntity>(
            predicate: #Predicate { $0.id > offset && $0.id <= offset + limit }
        )

        return try context.fetch(allDescriptor).sorted { $0.id < $1.id }
    }

    func fetchPokedexMetadata() throws -> [PokedexEntity] {
        let descriptor = FetchDescriptor<PokedexEntity>()
        return try context.fetch(descriptor)
    }

    func fetchPokemon(by name: String) async throws -> PokemonsEntity? {
        var descriptor = FetchDescriptor<PokemonsEntity>(
            predicate: #Predicate { $0.name == name }
        )
        descriptor.fetchLimit = 1

        if let localPokemon = try context.fetch(descriptor).first {
            return localPokemon
        }

        let pokemonAPI = PokeApiService(endpoint: .pokemonByName(name))

        let pokemonDetail: PokemonDetail = try await getData(
            from: pokemonAPI.url.absoluteString,
            type: PokemonDetail.self
        )

        let speciesDetail: PokemonSpeciesDetail = try await getData(
            from: pokemonDetail.species.url,
            type: PokemonSpeciesDetail.self
        )

        let evolutionChain: EvolutionChainResponse = try await getData(
            from: speciesDetail.evolutionChain.url,
            type: EvolutionChainResponse.self
        )

        let newPokemon = PokemonsEntity(
            name: pokemonDetail.name,
            url: pokemonAPI.url.absoluteString,
            id: pokemonDetail.id,
            imageURL: pokemonDetail.imageURL,
            imageShinyURL: pokemonDetail.imageShinyURL,
            color: speciesDetail.color.name,
            generation: speciesDetail.generation.name,
            flavorText: speciesDetail.englishFlavorText,
            types: pokemonDetail.types,
            nextEvolution: NextEvolution.getAll(
                from: evolutionChain.chain,
                currentPokemonName: pokemonDetail.name
            )
        )

        context.insert(newPokemon)
        try context.save()

        return newPokemon
    }

    func getData<T: Decodable>(
        from urlString: String,
        type: T.Type
    ) async throws -> T {
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
}
