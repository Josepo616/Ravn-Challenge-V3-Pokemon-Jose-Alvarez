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
    let pokemons: [PokemonUIModel]
    let listVM: ListVM
    let detailVM: DetailVM
    let showEmptyState: Bool

    var body: some View {
        ZStack {
            ScrollView {
                LazyVStack(spacing: 0) {
                    if showEmptyState {
                        EmptyStateView()
                    } else {
                        ForEach(pokemons, id: \.self) { pokemon in
                            NavigationLink(
                                destination: PokemonDetailView(
                                    pokemon: pokemon,
                                    detailVM: detailVM
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

                        if isSearchingMore {
                            LoadingView(text: "Loading more Pokémon...")
                        }
                    }
                }
                .padding(.horizontal, 16)
            }

            // Vista de búsqueda (si está activa)
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
