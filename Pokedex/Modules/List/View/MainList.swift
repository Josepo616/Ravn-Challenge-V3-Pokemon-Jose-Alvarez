//
//  ContentView.swift
//  Pokedex
//
//  Created by JoseAlvarez on 10/6/25.
//

import SwiftData
import SwiftUI

struct MainList: View {
    @StateObject var listVM: ListVM
    @State private var searchQuery: String = ""

    var body: some View {
        NavigationStack {
            ZStack {
                VStack(spacing: 0) {
                    SearchHeaderView(
                        searchQuery: $searchQuery,
                        isSearching: $listVM.isSearching,
                        onSearchChange: handleSearchChange,
                        onClearSearch: clearSearch
                    )

                    PokemonListView(
                        isSearching: $listVM.isSearching,
                        pokemons: listVM.filteredPokemons,
                        listVM: listVM
                    )
                }
            }
            .task {
                await listVM.fetchPokemons()
            }
        }
    }

    private func handleSearchChange(_ newValue: String) {
        listVM.handleSearchChange(newValue)
    }

    private func clearSearch() {
        searchQuery = ""
        listVM.clearSearch()
    }
}
