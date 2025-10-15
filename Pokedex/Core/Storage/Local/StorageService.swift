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

    func getCachedPokemons(offset: Int, limit: Int) throws -> [PokemonsEntity]? {
        let descriptor = FetchDescriptor<PokemonsEntity>(
            predicate: #Predicate { $0.id > offset && $0.id <= offset + limit }
        )
        let pokemons = try context.fetch(descriptor)
        return pokemons.isEmpty ? nil : pokemons.sorted { $0.id < $1.id }
    }

    func getCachedPokemon(by name: String) throws -> PokemonsEntity? {
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

    func savePokedexMetadataIfNeeded(response: PokedexResponse) throws {
        let existingCount = try context.fetchCount(FetchDescriptor<PokedexEntity>())
        guard existingCount == 0 else { return }

        let pokedex = PokedexEntity(
            count: response.count,
            next: response.next,
            previous: response.previous ?? "nil"
        )
        context.insert(pokedex)
    }

    func insertPokemon(_ pokemon: PokemonsEntity) {
        context.insert(pokemon)
    }

    func saveContext() throws {
        try context.save()
    }
}
