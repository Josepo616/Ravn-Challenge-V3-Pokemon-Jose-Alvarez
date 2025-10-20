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
    @ObservedObject var detailVM: DetailVM
    @Binding var searchQuery: String
    @State var language: Languages
    @State private var activeAlert: AlertType? = nil
    @State private var showEmptyState = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                SearchHeaderView(
                    searchQuery: $searchQuery,
                    isSearching: $listVM.isSearching,
                    language: $language,
                    onSearchChange: listVM.handleSearchChange,
                    onClearSearch: clearSearch
                )
                
                if activeAlert == .initialLoad {
                    ImageListErrorView()
                }
                
                PokemonListView(
                    isSearching: $listVM.isFetchingData,
                    isSearchingMore: $listVM.isFetchingMore,
                    pokemons: listVM.filteredPokemons,
                    listVM: listVM,
                    detailVM: detailVM,
                    showEmptyState: showEmptyState,
                    language: $language
                )
            }
            .task {
                await listVM.retryFetch()
            }
            .alert(item: $activeAlert) { alertType in
                switch alertType {
                case .initialLoad:
                    return AlertBuilder.initialLoadAlert(
                        fetchError: listVM.fetchError ?? PokemonError.connectivityIssue,
                        retryAction: {
                            Task { await listVM.retryFetch() }
                            activeAlert = nil
                        },
                        cancelAction: {
                            activeAlert = nil
                        }
                    )
                    
                case .searchEmpty:
                    return AlertBuilder.searchEmptyAlert {
                        showEmptyState = true
                        activeAlert = nil
                    }
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
                if !newQuery.isEmpty && !listVM.filteredPokemons.isEmpty {
                    showEmptyState = false
                }
            }
        }
    }

    private func clearSearch() {
        showEmptyState = false
        activeAlert = nil
        listVM.clearSearch()
    }
}
