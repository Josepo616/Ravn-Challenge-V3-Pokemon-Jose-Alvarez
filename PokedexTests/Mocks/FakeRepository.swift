//
//  FakeRepository.swift
//  Pokedex
//
//  Created by JoseAlvarez on 10/10/25.
//

import XCTest
import Foundation
@testable import Pokedex

@MainActor
final class FakeRepository: PokemonRepositoryProtocol {
    // Map offset -> pokemons to return for fetchAndStorePokemons
    var pokemonsByOffset: [Int: [PokemonsEntity]] = [:]
    var pokedexMetadataToReturn: [PokedexEntity] = []
    var pokemonByNameToReturn: [String: PokemonsEntity] = [:]

    // Controls for throwing errors
    var throwOnFetchAndStore: Error? = nil
    var throwOnFetchPokedexMetadata: Error? = nil
    var throwOnFetchPokemonByName: Error? = nil

    // Counters for verification
    var fetchAndStoreCallCount: Int = 0
    private(set) var fetchAndStoreLastOffset: Int? = nil
    private(set) var fetchPokemonByNameCallCount: Int = 0

    func fetchAndStorePokemons(offset: Int = 0, limit: Int = 50) async throws -> [PokemonsEntity] {
        fetchAndStoreCallCount += 1
        fetchAndStoreLastOffset = offset
        if let err = throwOnFetchAndStore { throw err }
        return pokemonsByOffset[offset] ?? []
    }

    func fetchPokedexMetadata() throws -> [PokedexEntity] {
        if let err = throwOnFetchPokedexMetadata { throw err }
        return pokedexMetadataToReturn
    }

    func fetchPokemon(by name: String) async throws -> PokemonsEntity? {
        fetchPokemonByNameCallCount += 1
        if let err = throwOnFetchPokemonByName { throw err }
        return pokemonByNameToReturn[name]
    }

    func getFetchError() -> Error? {
        return nil
    }
}
