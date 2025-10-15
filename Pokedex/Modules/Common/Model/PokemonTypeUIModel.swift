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
    
    init(slot: Int, typeName: String) {
        self.slot = slot
        self.typeName = typeName
    }
}
