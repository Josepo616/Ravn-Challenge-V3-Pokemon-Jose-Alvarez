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

    func fetchAndStorePokemons() async throws -> [PokemonsEntity] {
        let descriptor = FetchDescriptor<PokemonsEntity>()
        let localPokemons = try context.fetch(descriptor)

        if !localPokemons.isEmpty {
            return localPokemons
        }

        let pokemonAPI = PokeApiService(
            endpoint: .pokemon,
            parameter: ["offset": "0", "limit": "20"]
        )
        let response: PokedexResponse = try await getData(
            from: pokemonAPI.url.absoluteString,
            type: PokedexResponse.self
        )

        for result in response.results {
            let pokemonDetail: PokemonDetail = try await getData(
                from: result.url,
                type: PokemonDetail.self
            )
            
            let speciesDetail: PokemonSpeciesDetail = try await getData(
                from: pokemonDetail.species.url,
                type: PokemonSpeciesDetail.self
            )
            
            let color = speciesDetail.color.name
            let generation = speciesDetail.generation.name
            let flavorText = speciesDetail.englishFlavorText

            
            let evolutionChain: EvolutionChainResponse = try await getData(
                from: speciesDetail.evolutionChain.url,
                type: EvolutionChainResponse.self
            )
            
            let nextEvolution = NextEvolution(
                from: evolutionChain.chain,
                currentPokemonName: pokemonDetail.name
            )

            let newPokemon = PokemonsEntity(
                name: result.name,
                url: result.url,
                id: pokemonDetail.id,
                imageURL: pokemonDetail.imageURL,
                imageShinyURL: pokemonDetail.imageShinyURL,
                color: color,
                generation: generation,
                flavorText: flavorText,
                types: pokemonDetail.types,
                nextEvolution: nextEvolution
            )
            
            context.insert(newPokemon)
        }

        let pokedex = PokedexEntity(
            count: response.count,
            next: response.next,
            previous: response.previous ?? "nil"
        )
        context.insert(pokedex)

        try context.save()

        return try context.fetch(descriptor)
    }

    func fetchPokedexMetadata() throws -> [PokedexEntity] {
        let descriptor = FetchDescriptor<PokedexEntity>()
        return try context.fetch(descriptor)
    }
    
    func fetchPokemon(by name: String) throws -> PokemonsEntity? {
        var descriptor = FetchDescriptor<PokemonsEntity>(
            predicate: #Predicate { $0.name == name }
        )
        descriptor.fetchLimit = 1

        let results = try context.fetch(descriptor)
        return results.first
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
