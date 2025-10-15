//
//  StorageServiceProtocol.swift
//  Pokedex
//
//  Created by JoseAlvarez on 10/15/25.
//

import Foundation

protocol StorageServiceProtocol {
    func getCachedPokemons(offset: Int, limit: Int) throws -> [PokemonsEntity]?
    func getCachedPokemon(by name: String) throws -> PokemonsEntity?
    func fetchPokedexMetadata() throws -> [PokedexEntity]
    func savePokedexMetadataIfNeeded(response: PokedexResponse) throws
    func insertPokemon(_ pokemon: PokemonsEntity)
    func saveContext() throws
}
