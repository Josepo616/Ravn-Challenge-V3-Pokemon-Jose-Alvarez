//
//  NetworkServiceProtocol.swift
//  Pokedex
//
//  Created by JoseAlvarez on 10/15/25.
//

import Foundation

protocol NetworkServiceProtocol {
    func fetchPokemons(offset: Int, limit: Int) async throws -> PokedexResponse
    func fetchPokemonDetailByName(_ name: String) async throws -> PokemonDetailBundle
    func fetchPokemonDetail(from url: String, name: String) async throws -> PokemonDetailBundle
}
