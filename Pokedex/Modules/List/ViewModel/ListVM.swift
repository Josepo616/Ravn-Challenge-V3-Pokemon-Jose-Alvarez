//
//  ListVM.swift
//  Pokedex
//
//  Created by JoseAlvarez on 10/6/25.
//

import Foundation

@MainActor
class ListVM: ObservableObject {
    @Published private(set) var pokemon: [PokemonUIModel] = []
    @Published private(set) var pokedex: [PokedexEntity] = []
    @Published private(set) var offset: Int = 0
    @Published var isFetchingMore: Bool = false
    @Published var filteredPokemons: [PokemonUIModel] = []
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
            let pokedexEntities = try repository.fetchPokedexMetadata()
            self.pokedex = pokedexEntities
            let pokemonEntities = try await repository.loadPokemons(
                offset: 0,
                limit: limit
            )
            self.pokemon = pokemonEntities.map { $0.toUIModel() }
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

    func retryFetch() async {
        fetchError = nil
        do {
            try await fetchPokemons()
        } catch {
            fetchError = .connectivityIssue
        }
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

    func fetchPokemon(by name: String) async -> PokemonUIModel? {
        do {
            guard let pokemonEntity = try await repository.fetchPokemon(by: name)
            else { return nil }
            return pokemonEntity.toUIModel()
        } catch {
            return nil
        }
    }

    func loadMorePokemons() async {
        guard !isFetchingMore else { return }

        guard !isSearching && searchQuery.isEmpty else { return }

        isFetchingMore = true
        offset += limit
        do {
            let newPokemons = try await repository.loadPokemons(
                offset: offset,
                limit: limit
            )
            let newPokemonUIModels = newPokemons.map { $0.toUIModel() }
            let sortedNew = newPokemonUIModels.sorted { $0.id < $1.id }
            let newUnique = sortedNew.filter { new in
                !pokemon.contains(where: { $0.id == new.id })
            }
            pokemon.append(contentsOf: newUnique)
            filteredPokemons.append(contentsOf: newUnique)

        } catch {
            print("Error fetching more Pokémons: \(error.localizedDescription)")
        }
        isFetchingMore = false
    }

    func fixGeneration(_ generation: String) -> String {
        return
            generation
            .components(separatedBy: "-")
            .enumerated()
            .map { index, element in
                return index == 1 ? element.uppercased() : element.capitalized
            }
            .joined(separator: " ")
    }

    func fetchNextEvolutions(for pokemon: PokemonUIModel) async -> [PokemonUIModel] {
        guard !pokemon.nextEvolutions.isEmpty else { return [] }

        var evolutions: [PokemonUIModel] = []
        for evolutionName in pokemon.nextEvolutions {
            if let fetched = await fetchPokemon(by: evolutionName.name) {
                evolutions.append(fetched)
            }
        }
        return evolutions
    }
}
