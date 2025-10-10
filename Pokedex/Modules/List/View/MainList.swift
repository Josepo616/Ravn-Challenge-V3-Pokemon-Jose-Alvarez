//
//  MainList.swift
//  Pokedex
//
//  Created by JoseAlvarez on 10/7/25.
//

import SwiftData
import SwiftUI

struct MainList: View {
    @ObservedObject var listVM: ListVM
    @Binding var searchQuery: String
    @State private var activeAlert: AlertType? = nil
    @State private var showEmptyState = false
    @State private var lastSearchQuery: String = ""

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
                        isSearching: $listVM.isFetchingData,
                        pokemons: listVM.filteredPokemons,
                        listVM: listVM,
                        showEmptyState: showEmptyState
                    )
                }
            }
            .task {
                do {
                    try await listVM.fetchPokemons()
                } catch {
                    listVM.fetchError = .connectivityIssue
                }
            }
            .alert(item: $activeAlert) { alertType in
                switch alertType {
                case .initialLoad:
                    return Alert(
                        title: Text("Connectivity Issue"),
                        message: Text(listVM.fetchError?.localizedDescription ?? "An unknown error occurred."),
                        primaryButton: .default(Text("Try Again")) {
                            listVM.fetchError = nil
                            activeAlert = nil
                            Task {
                                do {
                                    listVM.isFetchingData = true
                                    try await listVM.fetchPokemons()
                                    listVM.isFetchingData = false
                                } catch {
                                    listVM.fetchError = .connectivityIssue
                                    listVM.isFetchingData = false
                                    activeAlert = .initialLoad
                                }
                            }
                        },
                        secondaryButton: .cancel {
                            activeAlert = nil
                        }
                    )
                    
                case .searchEmpty:
                    return Alert(
                        title: Text("There was an Error"),
                        message: Text(PokemonError.searchEmpty.localizedDescription),
                        dismissButton: .default(Text("OK")) {
                            showEmptyState = true
                            activeAlert = nil
                        }
                    )
                }
            }
            .onChange(of: listVM.fetchError) { _, error in
                if error != nil {
                    activeAlert = .initialLoad
                }
            }
            .onChange(of: listVM.filteredPokemons.count) { _, newCount in
                if newCount == 0 && !listVM.searchQuery.isEmpty {
                    if activeAlert != .initialLoad {
                        activeAlert = .searchEmpty
                    }
                }
            }
            .onChange(of: listVM.searchQuery) { _, newQuery in
                if !newQuery.isEmpty && !listVM.filteredPokemons.isEmpty{
                    showEmptyState = false
                }
            }
        }
    }

    private func handleSearchChange(_ newValue: String) {
        listVM.handleSearchChange(newValue)
    }

    private func clearSearch() {
        showEmptyState = false
        activeAlert = nil
        listVM.clearSearch()
    }
}
