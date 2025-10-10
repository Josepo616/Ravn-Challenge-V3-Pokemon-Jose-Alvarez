//
//  ListVM.swift
//  Pokedex
//
//  Created by JoseAlvarez on 10/6/25.
//

import Foundation

@MainActor
class ListVM: ObservableObject {
    @Published private(set) var pokemon: [PokemonsEntity] = []
    @Published private(set) var pokedex: [PokedexEntity] = []
    @Published private(set) var offset: Int = 0
    @Published var isFetchingMore: Bool = false
    @Published var filteredPokemons: [PokemonsEntity] = []
    @Published var isSearching: Bool = false
    @Published var isFetchingData: Bool = false
    @Published var searchQuery: String = ""
    @Published var fetchError: PokemonError?
    private let limit: Int = 50
    private let repository: PokemonRepositoryProtocol

    init(repository: PokemonRepositoryProtocol) {
        self.repository = repository
    }

    func fetchPokemons() async throws {
        if !self.pokemon.isEmpty { return }
        isFetchingData = true
        do {
            self.pokedex = try repository.fetchPokedexMetadata()
            self.pokemon = try await repository.fetchAndStorePokemons(
                offset: 0,
                limit: 50
            )
            self.pokemon.sort { $0.id < $1.id }
            self.filteredPokemons = self.pokemon
            isFetchingData = false
        } catch {
            if let urlError = error as? URLError,
                urlError.code == .notConnectedToInternet
            {
                throw PokemonError.connectivityIssue
            } else {
                throw PokemonError.unknown
            }
        }
    }

    func retryFetchPokemons() async {
        do {
            try await fetchPokemons()
        } catch {
            self.fetchError = error as? PokemonError ?? .unknown
        }
    }

    func formatID(_ id: Int) -> String {
        return String(format: "%04d", id)
    }

    func handleSearchChange(_ searchQuery: String) {
        self.searchQuery = searchQuery
        if searchQuery.isEmpty {
            filteredPokemons = pokemon
            isSearching = false
        } else {
            isSearching = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                self.filteredPokemons = self.pokemon.filter {
                    $0.name.lowercased().contains(searchQuery.lowercased())
                }
                self.isSearching = false
            }
        }
    }

    func clearSearch() {
        filteredPokemons = pokemon
        isSearching = false
        searchQuery = ""
    }

    func fetchPokemon(by name: String) async -> PokemonsEntity? {
        do {
            let pokemon = try await repository.fetchPokemon(by: name)
            return pokemon
        } catch {
            return nil
        }
    }

    func loadMorePokemons() async {
        guard !isFetchingMore else { return }

        guard !isSearching && searchQuery.isEmpty else { return }

        isFetchingMore = true
        offset += limit

        await MainActor.run {
            self.isFetchingMore = false
        }

        do {
            let newPokemons = try await repository.fetchAndStorePokemons(
                offset: offset,
                limit: limit
            )

            let sortedNew = newPokemons.sorted { $0.id < $1.id }
            let newUnique = sortedNew.filter { new in
                !pokemon.contains(where: { $0.id == new.id })
            }

            pokemon.append(contentsOf: newUnique)
            filteredPokemons.append(contentsOf: newUnique)

        } catch {
            print("Error fetching more Pokémons: \(error.localizedDescription)")
        }
    }
}
