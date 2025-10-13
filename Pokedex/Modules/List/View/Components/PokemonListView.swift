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

    var groupedPokemons: [(generation: String, pokemons: [PokemonsEntity])] {
        Dictionary(grouping: pokemons, by: { $0.generation ?? "Unknown" })
            .sorted(by: { $0.key < $1.key })
            .map { (generation: $0.key, pokemons: $0.value) }
    }

    var body: some View {
        ZStack {
            ScrollView {
                LazyVStack(spacing: 0) {
                    if showEmptyState {
                        EmptyStateView()
                    } else {

                        ForEach(groupedPokemons, id: \.generation) { group in
                            GenerationTitleView(
                                generation: group.generation,
                                listVM: listVM
                            )

                            ForEach(group.pokemons, id: \.self) { pokemon in
                                NavigationLink(
                                    destination: PokemonDetailView(
                                        pokemon: pokemon,
                                        listVM: listVM
                                    )
                                    .toolbarRole(.editor)
                                ) {
                                    PokemonRowView(
                                        pokemon: pokemon,
                                        listVM: listVM
                                    )
                                }
                                .buttonStyle(PlainButtonStyle())
                                .onLastItemAppear(
                                    currentItem: pokemon,
                                    lastItem: pokemons.last
                                ) {
                                    await listVM.loadMorePokemons()
                                }
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
