//
//  PokemonRepository.swift
//  Pokedex
//
//  Created by JoseAlvarez on 10/15/25.
//

import Foundation
import SwiftData

@MainActor
final class PokemonRepository: PokemonRepositoryProtocol {
    let context: ModelContext
    private let networkService: NetworkService
    private let storageService: StorageService
    private var fetchError: Error?

    init(
        context: ModelContext,
        networkService: NetworkService = NetworkService(),
        storageService: StorageService? = nil
    ) {
        self.context = context
        self.networkService = networkService
        self.storageService = storageService ?? StorageService(context: context)
    }

    // MARK: - Public Methods

    func loadPokemons(offset: Int = 0, limit: Int = 50) async throws
        -> [PokemonsEntity]
    {
        if let localPokemons = try storageService.getCatchedPokemons(
            offset: offset,
            limit: limit
        ), localPokemons.count == limit {
            return localPokemons
        }

        let response: PokedexResponse = try await networkService.fetchPokemons(
            offset: offset,
            limit: limit
        )
        try await storageService.fetchDetailsAndPersistPokemons(from: response.results)
        try storageService.savePokedexMetadataIfNeeded(response: response)

        return try storageService.getCatchedPokemons(
            offset: offset,
            limit: limit
        ) ?? []
    }

    func fetchPokedexMetadata() throws -> [PokedexEntity] {
        return try storageService.fetchPokedexMetadata()
    }

    func fetchPokemon(by name: String) async throws -> PokemonsEntity? {
        if let localPokemon = try storageService.getCatchedPokemon(by: name) {
            return localPokemon
        }
        let pokemon = try await networkService.getPokemonFromAPI(by: name)
        try storageService.persistPokemon(pokemon)
        return pokemon
    }

    func getFetchError() -> Error? {
        return fetchError
    }
}
