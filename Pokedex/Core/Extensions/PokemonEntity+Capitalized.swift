//
//  PokemonEntity+Capitalized.swift
//  Pokedex
//
//  Created by JoseAlvarez on 10/13/25.
//

import Foundation

extension PokemonUIModel {
    var formattedId: String {
        String(format: "%04d", id)
    }

    var displayName: String {
        "#\(formattedId) \(name.capitalized)"
    }
}

