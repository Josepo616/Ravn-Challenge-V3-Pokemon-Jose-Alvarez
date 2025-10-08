//
//  PokemonDetailView.swift
//  Pokedex
//
//  Created by JoseAlvarez on 10/7/25.
//

import SwiftUI

struct PokemonDetailView: View {
    @StateObject var viewModel: ListVM
    @State private var generationFixed = ""
    @State private var nextEvolution: PokemonsEntity?
    @State private var selectedTab = 0
    let pokemon: PokemonsEntity

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack() {
                ZStack {
                    Color(pokemon.color?.capitalized ?? "")
                        .frame(height: 300)

                    ImageHeaderSection(
                        selectedTab: $selectedTab,
                        pokemon: pokemon
                    )
                }

                InfoContentSection(
                    viewModel: viewModel,
                    pokemon: pokemon,
                    generationFixed: generationFixed,
                    nextEvolution: nextEvolution
                )
            }
        }
        .scrollDisabled(true)
        .navigationTitle("Pokemon Info")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            if let generation = pokemon.generation {
                generationFixed = generation
                    .components(separatedBy: "-")
                    .map { $0.capitalized }
                    .joined(separator: " ")
            } else {
                generationFixed = "Unknown"
            }

            Task {
                await loadNextEvolution()
            }
        }
    }

    private func loadNextEvolution() async {
        guard let evolutionName = pokemon.nextEvolutionName, !evolutionName.isEmpty else { return }
        nextEvolution = await viewModel.fetchPokemon(by: evolutionName)
    }
}
