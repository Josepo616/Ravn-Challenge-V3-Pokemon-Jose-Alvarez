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

    func fetchPokemons(offset: Int, limit: Int) async throws -> PokedexResponse
    {
        let pokemonAPI = PokeApiService(
            endpoint: .pokemon,
            parameters: [.limit: "\(limit)", .offset: "\(offset)"]
        )
        return try await getData(
            from: pokemonAPI.url.absoluteString,
            type: PokedexResponse.self
        )
    }

    func getPokemonFromAPI(by name: String) async throws -> PokemonsEntity {
        let pokemonAPI = PokeApiService(endpoint: .pokemonByName(name))
        let pokemon: PokemonsEntity = try await fetchAndCreatePokemon(
            urlString: pokemonAPI.url.absoluteString,
            name: name
        )
        return pokemon
    }

    private func getData<T: Decodable>(from urlString: String, type: T.Type)
        async throws -> T
    {
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

    func fetchAndCreatePokemon(urlString: String, name: String)
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

    private func fetchLinkedResources<
        T1: Decodable,
        T2: Decodable,
        T3: Decodable
    >(rootURL: String, speciesURL: (T1) -> String, evolutionURL: (T2) -> String)
        async throws -> (T1, T2, T3)
    {
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
            evolutionTrigger: nextEvolutions.first?.triggerName ?? "",
            isLegendary: species.isLegendary,
            types: detail.types,
            nextEvolution: nextEvolutions
        )
    }
}
