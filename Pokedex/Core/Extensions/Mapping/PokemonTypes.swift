//
//  PokemonTypes.swift
//  Pokedex
//
//  Created by JoseAlvarez on 10/14/25.
//

import Foundation

extension PokemonTypeEntity {
    func toPokemonType() -> PokemonType {
        return PokemonType(
            slot: self.slot,
            type: TypeDetails(name: self.typeName, url: self.typeURL)
        )
    }
}
