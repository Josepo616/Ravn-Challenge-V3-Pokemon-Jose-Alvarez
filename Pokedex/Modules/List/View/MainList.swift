import SwiftData
import SwiftUI

struct MainList: View {
    @ObservedObject var listVM: ListVM
    @State private var searchQuery: String = ""
    @State private var showAlert = false

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
                do {
                    try await listVM.fetchPokemons()
                } catch {
                    listVM.fetchError = .connectivityIssue
                }
            }
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("Connectivity Issue"),
                    message: Text(listVM.fetchError?.localizedDescription ?? "An unknown error occurred."),
                    primaryButton: .default(Text("Try Again")) {
                        listVM.fetchError = nil
                        Task {
                            do {
                                try await listVM.fetchPokemons()
                            } catch {
                                listVM.fetchError = .connectivityIssue
                            }
                        }
                    },
                    secondaryButton: .cancel()
                )
            }
            .onChange(of: listVM.fetchError) { _, error in
                if error != nil {
                    showAlert = true
                }
            }
        }
    }

    private func handleSearchChange(_ newValue: String) {
        listVM.handleSearchChange(newValue)
    }

    private func clearSearch() {
        listVM.clearSearch()
    }
}
