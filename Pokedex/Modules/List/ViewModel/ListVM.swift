//
//  ListVM.swift
//  Pokedex
//
//  Created by JoseAlvarez on 10/6/25.
//

import Foundation

@MainActor
class ListVM: ObservableObject {
    @Published private(set) var pokemon: [PokemonEntity] = []
    @Published private(set) var pokedex: [PokedexEntity] = []
    private let repository: PokemonRepository

    init(repository: PokemonRepository) {
        self.repository = repository
    }

    func fetchPokemons() async {
        do {
            self.pokedex = try repository.fetchPokedexMetadata()
            self.pokemon = try await repository.fetchAndStorePokemons()
            self.pokemon.sort { $0.id < $1.id }
        } catch {
            print("Error al obtener pokemons: \(error.localizedDescription)")
        }
    }
}

