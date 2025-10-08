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
        List {
            if pokemons.isEmpty {
                EmptyStateView()
                    .listRowSeparator(.hidden)
            } else {
                ForEach(pokemons, id: \.self) { pokemon in
                    NavigationLink(
                        destination: PokemonDetailView(
                            viewModel: listVM,
                            pokemon: pokemon
                        )
                        .toolbarRole(.editor)
                    ) {
                        PokemonRowView(pokemon: pokemon, listVM: listVM)
                            .listRowInsets(
                                EdgeInsets(
                                    top: 4,
                                    leading: 16,
                                    bottom: 4,
                                    trailing: 16
                                )
                            )
                            .listRowBackground(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color(.systemGray6))
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                            )
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                .listRowSeparator(.hidden)
            }
        }
        .listStyle(.plain)
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
