import Foundation

protocol PokemonRepositoryType {
    func fetchAndStorePokemons(offset: Int, limit: Int) async throws -> [PokemonsEntity]
    func fetchAndStorePokemons() async throws -> [PokemonsEntity]
    func fetchPokedexMetadata() throws -> [PokedexEntity]
    func fetchPokemon(by name: String) throws -> PokemonsEntity?
}
