//
//  PokemonTypeUIModel.swift
//  Pokedex
//
//  Created by JoseAlvarez on 10/15/25.
//

import Foundation

struct PokemonTypeUIModel: Hashable {
    var slot: Int
    var typeName: String
    var typeURL: String
    var pokemon: PokemonUIModel?
    
    init(slot: Int, typeName: String, typeURL: String) {
        self.slot = slot
        self.typeName = typeName
        self.typeURL = typeURL
    }
}
