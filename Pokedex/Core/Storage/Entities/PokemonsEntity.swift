//
//  PokedexEntity.swift
//  Pokedex
//
//  Created by JoseAlvarez on 10/6/25.
//

import Foundation
import SwiftData

@Model
class PokemonsEntity: Hashable {
    var id: Int
    var name: String
    var url: String
    var imageURL: String?
    var imageShinyURL: String?
    @Relationship(deleteRule: .cascade, inverse: \PokemonTypeEntity.pokemon)
    var types: [PokemonTypeEntity] = []

    init(
        name: String,
        url: String,
        id: Int,
        imageURL: String?,
        imageShinyURL: String?,
        types: [PokemonType]
    ) {
        self.name = name
        self.url = url
        self.id = id
        self.imageURL = imageURL
        self.imageShinyURL = imageShinyURL
        self.types = types.map {
            PokemonTypeEntity(
                slot: $0.slot,
                typeName: $0.type.name,
                typeURL: $0.type.url
            )
        }
    }

    static func == (lhs: PokemonsEntity, rhs: PokemonsEntity) -> Bool {
        return lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
