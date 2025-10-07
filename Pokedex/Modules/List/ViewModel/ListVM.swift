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
    private let repository: PokemonRepository

    init(repository: PokemonRepository) {
        self.repository = repository
    }

    func fetchPokemons() async {
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

    func updatePokemonPropertyIfNeeded(pokemon: PokemonsEntity) async {
        if pokemon.imageShinyURL == nil {
            do {
                try await repository.updateComponentProperty(
                    componentType: PokemonsEntity.self,
                    propertyKey: \PokemonsEntity.imageShinyURL,
                    fetchURL: { $0.url },
                    fetchProperty: { url in
                        let pokemonDetail: PokemonDetail =
                            try await self.repository.getData(
                                from: url,
                                type: PokemonDetail.self
                            )
                        let imageShinyURL = pokemonDetail.imageShinyURL ?? ""
                        return imageShinyURL
                    }
                )
            } catch {
                print(
                    "Error updating shiny image for \(pokemon.name): \(error.localizedDescription)"
                )
            }
        }
    }
}
