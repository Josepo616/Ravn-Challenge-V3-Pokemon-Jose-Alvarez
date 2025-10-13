//
//  PokemonDetailView.swift
//  Pokedex
//
//  Created by JoseAlvarez on 10/7/25.
//

import SwiftUI

struct PokemonDetailView: View {
    @State private var nextEvolutions: [PokemonsEntity] = []
    @State private var selectedTab = 0
    let pokemon: PokemonsEntity
    var listVM: ListVM

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack {
                ZStack {
                    Color(pokemon.color?.capitalized ?? "")
                        .frame(height: 300)
                        .ignoresSafeArea(edges: .top)

                    ImageHeaderSection(
                        selectedTab: $selectedTab,
                        pokemon: pokemon
                    )
                }

                InfoContentSection(
                    listVM: listVM,
                    pokemon: pokemon,
                    nextEvolutions: nextEvolutions
                )
            }
        }
        .navigationTitle("Pokemon Info")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            nextEvolutions = await listVM.fetchNextEvolutions(for: pokemon)
        }
    }
}
