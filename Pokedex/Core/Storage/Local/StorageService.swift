//
//  StorageService.swift
//  Pokedex
//
//  Created by JoseAlvarez on 10/15/25.
//

import Foundation
import SwiftData

final class StorageService {
    private let context: ModelContext

    init(context: ModelContext) {
        self.context = context
    }

    func getCatchedPokemons(offset: Int, limit: Int) throws -> [PokemonsEntity]?
    {
        let descriptor = FetchDescriptor<PokemonsEntity>(
            predicate: #Predicate { $0.id > offset && $0.id <= offset + limit }
        )
        let pokemons = try context.fetch(descriptor)
        return pokemons.isEmpty ? nil : sortedPokemonsById(pokemons)
    }

    func getCatchedPokemon(by name: String) throws -> PokemonsEntity? {
        var descriptor = FetchDescriptor<PokemonsEntity>(
            predicate: #Predicate { $0.name == name }
        )
        descriptor.fetchLimit = 1
        return try context.fetch(descriptor).first
    }

    func fetchPokedexMetadata() throws -> [PokedexEntity] {
        let descriptor = FetchDescriptor<PokedexEntity>()
        return try context.fetch(descriptor)
    }

    func fetchDetailsAndPersistPokemons(from results: [Pokedex]) async throws {
        var newPokemons: [PokemonsEntity] = []
        for result in results {
            if let existingPokemon = try fetchLocalPokemon(byUrl: result.url) {
                context.delete(existingPokemon)
            }
            let pokemon = try await NetworkService().fetchAndCreatePokemon(
                urlString: result.url,
                name: result.name
            )
            context.insert(pokemon)
            newPokemons.append(pokemon)
            try persistPokemon(pokemon)
        }
    }

    func savePokedexMetadataIfNeeded(response: PokedexResponse) throws {
        let existingPokedexCount = try context.fetchCount(
            FetchDescriptor<PokedexEntity>()
        )
        if existingPokedexCount == 0 {
            let pokedex = PokedexEntity(
                count: response.count,
                next: response.next,
                previous: response.previous ?? "nil"
            )
            context.insert(pokedex)
        }
    }

    func persistPokemon(_ pokemon: PokemonsEntity) throws {
        context.insert(pokemon)
        try context.save()
    }

    private func fetchLocalPokemon(byUrl url: String) throws -> PokemonsEntity?
    {
        let descriptor = FetchDescriptor<PokemonsEntity>(
            predicate: #Predicate { $0.url == url }
        )
        return try context.fetch(descriptor).first
    }

    private func sortedPokemonsById(_ pokemons: [PokemonsEntity])
        -> [PokemonsEntity]
    {
        return pokemons.sorted { $0.id < $1.id }
    }
}
