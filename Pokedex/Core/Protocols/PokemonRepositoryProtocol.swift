//
//  PokemonRepositoryProtocol.swift
//  Pokedex
//
//  Created by JoseAlvarez on 10/10/25.
//


import Foundation
import SwiftData

@MainActor
protocol PokemonRepositoryProtocol {
    func loadPokemons(offset: Int, limit: Int) async throws -> [PokemonsEntity]
    func fetchPokedexMetadata() throws -> [PokedexEntity]
    func fetchPokemon(by name: String) async throws -> PokemonsEntity?
    func getFetchError() -> Error?
}
