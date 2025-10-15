//
//  DetailVM.swift
//  Pokedex
//
//  Created by JoseAlvarez on 10/15/25.
//

import Foundation

@MainActor
class DetailVM: ObservableObject {
    @Published var nextEvolutions: [PokemonUIModel] = []
    @Published var isFetchingEvolutions: Bool = false
    @Published var fetchError: PokemonError?

    private let listVM: ListVM

    init(listVM: ListVM) {
        self.listVM = listVM
    }

    func fetchNextEvolutions(for pokemon: PokemonUIModel) async -> [PokemonUIModel] {
        guard !pokemon.nextEvolutions.isEmpty else { return [] }

        var evolutions: [PokemonUIModel] = []
        for evolutionName in pokemon.nextEvolutions {
            if let fetched = await listVM.fetchPokemon(by: evolutionName.name) {
                evolutions.append(fetched)
            }
        }
        return evolutions
    }
}
