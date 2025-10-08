import Foundation
@testable import Pokedex

final class MockPokemonRepository: PokemonRepositoryType {
    var pokemonsToReturn: [PokemonsEntity] = []
    var pokedexToReturn: [PokedexEntity] = []

    func fetchAndStorePokemons(offset: Int = 0, limit: Int = 50) async throws -> [PokemonsEntity] {
        // Simula paginación simplemente devolviendo slice según offset/limit
        let start = offset
        let end = min(offset + limit, pokemonsToReturn.count)
        guard start < end else { return [] }
        return Array(pokemonsToReturn[start..<end])
    }

    func fetchAndStorePokemons() async throws -> [PokemonsEntity] {
        return try await fetchAndStorePokemons(offset: 0, limit: pokemonsToReturn.count)
    }

    func fetchPokedexMetadata() throws -> [PokedexEntity] {
        return pokedexToReturn
    }

    func fetchPokemon(by name: String) throws -> PokemonsEntity? {
        return pokemonsToReturn.first { $0.name == name }
    }
}
