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
    @Published var filteredPokemons: [PokemonsEntity] = []
    @Published var isSearching: Bool = false
    @Published private(set) var offset: Int = 0
    @Published var searchQuery: String = ""
    private let limit: Int = 50
    private var isFetchingMore: Bool = false
    private let repository: PokemonRepository

    init(repository: PokemonRepository) {
        self.repository = repository
    }

    func fetchPokemons() async {
        if !self.pokemon.isEmpty { return }

        do {
            self.pokedex = try repository.fetchPokedexMetadata()
            self.pokemon = try await repository.fetchAndStorePokemons()
            self.pokemon.sort { $0.id < $1.id }
            self.filteredPokemons = self.pokemon
        } catch {
            print("Error fetching pokemons: \(error.localizedDescription)")
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
    }

    func fetchPokemon(by name: String) async -> PokemonsEntity? {
        do {
            let pokemon = try repository.fetchPokemon(by: name)
            return pokemon
        } catch {
            print(
                "Error fetching Pokémon named \(name): \(error.localizedDescription)"
            )
            return nil
        }
    }

    func loadMorePokemons() async {
        guard !isFetchingMore else { return }

        guard !isSearching && searchQuery.isEmpty else { return }

        isFetchingMore = true
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        offset += limit
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
        isSearching = false
        isFetchingMore = false
    }
}
