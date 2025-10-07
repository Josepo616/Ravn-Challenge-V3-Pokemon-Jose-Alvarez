//
//  ContentView.swift
//  Pokedex
//
//  Created by JoseAlvarez on 10/6/25.
//

import SwiftData
import SwiftUI

struct ContentView: View {
    @StateObject var listVM: ListVM
    @State private var searchQuery: String = ""
    @State private var isSearching: Bool = false
    @State private var filteredPokemons: [PokemonsEntity] = []

    var body: some View {
        VStack(spacing: 0) {
            SearchHeaderView(
                searchQuery: $searchQuery,
                isSearching: $isSearching,
                onSearchChange: handleSearchChange,
                onClearSearch: clearSearch
            )

            PokemonListView(
                isSearching: $isSearching,
                pokemons: filteredPokemons,
                listVM: listVM
            )
        }
        .task {
            await listVM.fetchPokemons()
            filteredPokemons = listVM.pokemon
        }
    }

    private func handleSearchChange(_ newValue: String) {
        if newValue.isEmpty {
            filteredPokemons = listVM.pokemon
            isSearching = false
        } else {
            isSearching = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                filteredPokemons = listVM.pokemon.filter {
                    $0.name.lowercased().contains(newValue.lowercased())
                }
                if filteredPokemons.isEmpty {
                    filteredPokemons = []
                }
                isSearching = false
            }
        }
    }

    private func clearSearch() {
        searchQuery = ""
        filteredPokemons = listVM.pokemon
        isSearching = false
    }
}
