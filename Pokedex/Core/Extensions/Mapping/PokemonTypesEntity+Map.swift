//
//  PokemonTypes.swift
//  Pokedex
//
//  Created by JoseAlvarez on 10/14/25.
//

import Foundation

extension PokemonTypeEntity {
    func toPokemonType() -> PokemonTypeUIModel {
        return PokemonTypeUIModel(
            slot: self.slot,
            typeName: self.typeName
        )
    }
}
