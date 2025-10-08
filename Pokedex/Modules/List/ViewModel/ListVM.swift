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
    private let limit: Int = 20
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
            let pokemon = try await repository.fetchPokemon(by: name)
            return pokemon
        } catch {
            print("Error fetching Pokémon named \(name): \(error.localizedDescription)")
            return nil
        }
    }
    
    func loadMorePokemons() async {
        guard !isFetchingMore else { return }

        isFetchingMore = true

        try? await Task.sleep(nanoseconds: 1_000_000_000) // opcional: simula carga

        offset += limit

        do {
            let newPokemons = try await repository.fetchAndStorePokemons(offset: offset, limit: limit)
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


    /*func updatePokemonPropertiesIfNeeded(pokemon: PokemonsEntity) async {
        let propertiesToUpdate: [
            (WritableKeyPath<PokemonsEntity, String?>, (PokemonsEntity) -> String, (PokemonDetail) -> String?)
        ] = [
            (\PokemonsEntity.imageShinyURL, { $0.url }, { $0.imageShinyURL }),
            (\PokemonsEntity.evolvesTo, { $0.url }, { $0.species.name })  // Aquí solo sacamos el nombre de la evolución
        ]
        
        for (propertyKey, fetchURL, mapProperty) in propertiesToUpdate {
            if pokemon[keyPath: propertyKey] == nil {
                print("Property \(propertyKey) is nil for Pokémon \(pokemon.name) (\(pokemon.id)), proceeding with update...")
                
                do {
                    let urlToFetch = fetchURL(pokemon)  // La URL original del Pokémon (https://pokeapi.co/api/v2/pokemon/1/)
                    print("Fetching data from URL: \(urlToFetch) for Pokémon \(pokemon.name) (\(pokemon.id))")
                    
                    try await repository.updateComponentProperty(
                        componentType: PokemonsEntity.self,
                        propertyKey: propertyKey,
                        fetchURL: fetchURL,
                        fetchProperty: { url in
                            print("Fetching Pokémon data from URL: \(urlToFetch)")
                            
                            // 1. Obtener los detalles del Pokémon
                            let pokemonDetail: PokemonDetail = try await self.repository.getData(
                                from: urlToFetch,
                                type: PokemonDetail.self
                            )
                            
                            // 2. Obtener la URL de la especie (la evolución) que viene en el campo "species"
                            let speciesURL = pokemonDetail.species.url
                            print("Evolves to species URL: \(speciesURL)")

                            // 3. Hacer una llamada a esa URL para obtener los detalles de la especie
                            let speciesDetail: PokemonSpeciesDetail = try await self.repository.getData(
                                from: speciesURL,
                                type: PokemonSpeciesDetail.self
                            )
                            
                            // Imprimir la respuesta JSON para verificar que estamos obteniendo la evolución
                            print("Fetched Pokémon Species Detail: \(speciesDetail)")

                            // 4. Obtener la URL de la cadena de evolución desde `evolutionChain`
                            let evolutionChainURL = speciesDetail.evolutionChain.url
                            print("Fetching Evolution Chain from URL: \(evolutionChainURL)")

                            // 5. Obtener la cadena de evolución
                            let evolutionChain: EvolutionChainDetail = try await self.repository.getData(
                                from: evolutionChainURL,
                                type: EvolutionChainDetail.self
                            )

                            // 6. Extraer el nombre de la última evolución
                            let evolutionName = evolutionChain.chain.extractEvolutionName()
                            print("Evolution name: \(evolutionName ?? "nil")")

                            // 7. Actualizamos la propiedad con el nombre de la evolución
                            return evolutionName ?? ""
                        }
                    )
                    
                    print("Successfully updated property \(propertyKey) for Pokémon \(pokemon.name) (\(pokemon.id))")
                } catch {
                    print("Error updating property \(propertyKey) for Pokémon \(pokemon.name) (\(pokemon.id)): \(error.localizedDescription)")
                }
            } else {
                print("Property \(propertyKey) already has a value for Pokémon \(pokemon.name) (\(pokemon.id)), skipping update.")
            }
        }
    }*/
}
