//
//  PokemonListView.swift
//  Pokedex
//
//  Created by JoseAlvarez on 10/7/25.
//

import SwiftUI

struct PokemonListView: View {
    @Binding var isSearching: Bool
    let pokemons: [PokemonsEntity]
    let listVM: ListVM

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                if pokemons.isEmpty {
                    EmptyStateView()
                } else {
                    ForEach(pokemons, id: \.self) { pokemon in
                        NavigationLink(
                            destination: PokemonDetailView(
                                pokemon: pokemon,
                                viewModel: listVM
                            )
                            .toolbarRole(.editor)
                        ) {
                            PokemonRowView(pokemon: pokemon, listVM: listVM)
                        }
                        .buttonStyle(PlainButtonStyle())
                        .onAppear {
                            if pokemon == pokemons.last {
                                Task {
                                    await listVM.loadMorePokemons()
                                }
                            }
                        }
                    }
                }
            }
            .padding(.horizontal, 16)
        }
        .background(Color.white)

        if isSearching {
            ZStack {
                Color.white.opacity(0.5)
                    .edgesIgnoringSafeArea(.all)

                ProgressView()
                    .scaleEffect(2)
                    .progressViewStyle(CircularProgressViewStyle())
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
    }
}
