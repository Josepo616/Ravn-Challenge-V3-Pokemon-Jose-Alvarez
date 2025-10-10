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

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                if showEmptyState {
                    EmptyStateView()
                } else {
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
                        .onAppear {
                            if pokemon == pokemons.last {
                                print("Last Pokémon reached, calling loadMorePokemons()")
                                Task {
                                    await listVM.loadMorePokemons()
                                }
                            }
                        }
                    }
                    if isSearchingMore {
                        Text("Loading more Pokémon...")
                            .font(.headline)
                            .foregroundColor(.gray)
                            .padding()
                        ProgressView()
                    }
                }
            }
            .padding(.horizontal, 16)
        }

        if isSearching {
            ZStack {
                Color.white.opacity(0.5)
                    .edgesIgnoringSafeArea(.all)

                ProgressView()
                    .scaleEffect(2)
                    .progressViewStyle(CircularProgressViewStyle())
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .offset(y: -250)
            }
        }
    }
}
