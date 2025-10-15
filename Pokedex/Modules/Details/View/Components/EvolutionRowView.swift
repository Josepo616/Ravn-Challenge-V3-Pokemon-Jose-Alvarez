//
//  EvolutionRowView.swift
//  Pokedex
//
//  Created by JoseAlvarez on 10/13/25.
//

import SwiftUI

struct EvolutionRowView: View {
    let basePokemon: PokemonUIModel
    let evolution: PokemonUIModel
    let detailVM: DetailVM

    var body: some View {
        HStack(spacing: 16) {
            PokemonEvolutionCard(pokemon: basePokemon, detailVM: detailVM)
            EvolutionArrowView(trigger: basePokemon.evolutionTrigger ?? "Unknown")
            NavigationLink(
                destination: PokemonDetailView(
                    pokemon: evolution,
                    detailVM: detailVM
                )
                .toolbarRole(.editor)
            ) {
                PokemonEvolutionCard(pokemon: evolution, detailVM: detailVM)
            }
            .buttonStyle(.plain)
        }
    }
}
