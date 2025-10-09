//
//  EvolutionSection.swift
//  Pokedex
//
//  Created by JoseAlvarez on 10/8/25.
//

import SwiftUI

struct EvolutionSection: View {
    let listVM: ListVM
    let pokemon: PokemonsEntity
    let nextEvolutions: [PokemonsEntity]

    var body: some View {
        VStack(alignment: .center, spacing: 16) {
            Text("Evolutions")
                .font(.system(size: 22, weight: .bold))
                .padding(.top, 8)

            Group {
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 20) {
                        ForEach(nextEvolutions, id: \.id) { evolution in
                            HStack(spacing: 16) {
                                PokemonEvolutionCard(
                                    pokemon: pokemon,
                                    listVM: listVM
                                )

                                EvolutionArrowView(trigger: pokemon.evolutionTrigger)

                                NavigationLink(
                                    destination: PokemonDetailView(
                                        pokemon: evolution,
                                        listVM: listVM
                                    )
                                    .toolbarRole(.editor)
                                ) {
                                    PokemonEvolutionCard(
                                        pokemon: evolution,
                                        listVM: listVM
                                    )
                                }
                                .buttonStyle(.plain)
                            }
                        }
                    }
                    .padding(.vertical, 8)
                }
            }
        }
        .padding(.horizontal)
    }
}
