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
    private let networkService: NetworkService
    private let storageService: StorageService
    private let context: ModelContext
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

    func loadPokemons(offset: Int = 0, limit: Int = 50) async throws -> [PokemonsEntity] {
        if let cached = try storageService.getCachedPokemons(offset: offset, limit: limit),
           cached.count == limit {
            return cached
        }

        let response = try await networkService.fetchPokemons(offset: offset, limit: limit)

        for result in response.results {
            let bundle = try await networkService.fetchPokemonDetail(from: result.url, name: result.name)
            let entity = PokemonMapper.map(bundle: bundle)
            storageService.insertPokemon(entity)
        }

        try storageService.saveContext()
        try storageService.savePokedexMetadataIfNeeded(response: response)

        return try storageService.getCachedPokemons(offset: offset, limit: limit) ?? []
    }

    func fetchPokedexMetadata() throws -> [PokedexEntity] {
        return try storageService.fetchPokedexMetadata()
    }

    func fetchPokemon(by name: String) async throws -> PokemonsEntity? {
        if let local = try storageService.getCachedPokemon(by: name) {
            return local
        }

        let bundle = try await networkService.fetchPokemonDetailByName(name)
        let entity = PokemonMapper.map(bundle: bundle)
        storageService.insertPokemon(entity)
        try storageService.saveContext()
        return entity
    }

    func getFetchError() -> Error? {
        return fetchError
    }
}
