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

            let newPokemon = PokemonsEntity(
                name: result.name,
                url: result.url,
                id: pokemonDetail.id,
                imageURL: pokemonDetail.imageURL,
                types: pokemonDetail.types
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

    private func getData<T: Decodable>(
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
}
