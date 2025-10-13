//
//  PokemonListView.swift
//  Pokedex
//
//  Created by JoseAlvarez on 10/7/25.
//

import SwiftUI

struct PokemonListView: View {
    @Binding var isSearching: Bool
    @Binding var isSearchingMore: Bool
    let pokemons: [PokemonsEntity]
    let listVM: ListVM
    let showEmptyState: Bool

    private var generationLabel: String {
        guard let first = pokemons.first else { return "" }
        return listVM.fixGeneration(first.generation ?? "")
    }

    var body: some View {
        ZStack {
            ScrollView {
                LazyVStack(spacing: 0) {
                    if showEmptyState {
                        EmptyStateView()
                    } else {
                        if !generationLabel.isEmpty {
                            Text(generationLabel)
                        }

                        ForEach(pokemons, id: \.self) { pokemon in
                            NavigationLink(
                                destination: PokemonDetailView(
                                    pokemon: pokemon,
                                    listVM: listVM
                                )
                                .toolbarRole(.editor)
                            ) {
                                PokemonRowView(pokemon: pokemon, listVM: listVM)
                            }
                            .buttonStyle(PlainButtonStyle())
                            .onLastItemAppear(
                                currentItem: pokemon,
                                lastItem: pokemons.last
                            ) {
                                await listVM.loadMorePokemons()
                            }
                        }

                        if isSearchingMore {
                            LoadingView(text: "Loading more Pokémon...")
                        }
                    }
                }
                .padding(.horizontal, 16)
            }

            if isSearching {
                ProgressView()
                    .scaleEffect(2)
                    .progressViewStyle(CircularProgressViewStyle())
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .offset(y: -50)
            }
        }
    }
}
