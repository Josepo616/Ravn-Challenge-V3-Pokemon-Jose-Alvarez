//
//  PokemonTypeEntity.swift
//  Pokedex
//
//  Created by JoseAlvarez on 10/6/25.
//

import SwiftData

@Model
class PokemonTypeEntity {
    var slot: Int
    var typeName: String
    var typeURL: String
    var pokemon: PokemonsEntity?

    init(slot: Int, typeName: String, typeURL: String) {
        self.slot = slot
        self.typeName = typeName
        self.typeURL = typeURL
    }
}
