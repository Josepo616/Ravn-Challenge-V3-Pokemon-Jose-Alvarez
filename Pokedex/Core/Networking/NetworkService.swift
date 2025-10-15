//
//  NetworkService.swift
//  Pokedex
//
//  Created by JoseAlvarez on 10/15/25.
//

import Foundation

final class NetworkService {
    private let jsonDecoder = JSONDecoder()
    private let session: URLSession

    init(session: URLSession = .shared) {
        self.session = session
    }

    // MARK: - Public

    func fetchPokemons(offset: Int, limit: Int) async throws -> PokedexResponse
    {
        let api = PokeApiService(
            endpoint: .pokemon,
            parameters: [.limit: "\(limit)", .offset: "\(offset)"]
        )
        return try await fetchData(
            from: api.url.absoluteString,
            as: PokedexResponse.self
        )
    }

    func fetchPokemonDetailByName(_ name: String) async throws
        -> PokemonDetailBundle
    {
        let api = PokeApiService(endpoint: .pokemonByName(name))
        return try await fetchPokemonDetail(
            from: api.url.absoluteString,
            name: name
        )
    }

    func fetchPokemonDetail(from url: String, name: String) async throws
        -> PokemonDetailBundle
    {
        let (detail, species, evolution):
            (
                PokemonDetail,
                PokemonSpeciesDetail,
                EvolutionChainResponse
            ) = try await fetchLinkedResources(
                rootURL: url,
                speciesURL: { $0.species.url },
                evolutionURL: { $0.evolutionChain.url }
            )

        return PokemonDetailBundle(
            name: name,
            url: url,
            detail: detail,
            species: species,
            evolution: evolution
        )
    }

    // MARK: - Private Helpers

    private func fetchData<T: Decodable>(
        from urlString: String,
        as type: T.Type
    ) async throws -> T {
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }

        let (data, response) = try await session.data(from: url)

        guard let httpResponse = response as? HTTPURLResponse,
            (200...299).contains(httpResponse.statusCode)
        else {
            throw URLError(.badServerResponse)
        }

        return try jsonDecoder.decode(T.self, from: data)
    }

    private func fetchLinkedResources<
        T1: Decodable,
        T2: Decodable,
        T3: Decodable
    >(
        rootURL: String,
        speciesURL: (T1) -> String,
        evolutionURL: (T2) -> String
    ) async throws -> (T1, T2, T3) {
        let detail: T1 = try await fetchData(from: rootURL, as: T1.self)
        let species: T2 = try await fetchData(
            from: speciesURL(detail),
            as: T2.self
        )
        let evolution: T3 = try await fetchData(
            from: evolutionURL(species),
            as: T3.self
        )
        return (detail, species, evolution)
    }
}
