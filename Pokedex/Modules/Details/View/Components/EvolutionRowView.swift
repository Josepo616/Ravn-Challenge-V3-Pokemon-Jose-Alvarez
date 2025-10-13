//
//  EvolutionRowView.swift
//  Pokedex
//
//  Created by JoseAlvarez on 10/13/25.
//

import SwiftUI

struct EvolutionRowView: View {
    let basePokemon: PokemonsEntity
    let evolution: PokemonsEntity
    let listVM: ListVM

    var body: some View {
        HStack(spacing: 16) {
            PokemonEvolutionCard(pokemon: basePokemon, listVM: listVM)
            EvolutionArrowView(trigger: basePokemon.evolutionTrigger ?? "Unknown")
            NavigationLink(
                destination: PokemonDetailView(
                    pokemon: evolution,
                    listVM: listVM
                )
                .toolbarRole(.editor)
            ) {
                PokemonEvolutionCard(pokemon: evolution, listVM: listVM)
            }
            .buttonStyle(.plain)
        }
    }
}
