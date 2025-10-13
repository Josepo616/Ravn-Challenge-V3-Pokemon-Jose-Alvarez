//
//  PokemonEntity+SizeFixed.swift
//  Pokedex
//
//  Created by JoseAlvarez on 10/13/25.
//

import Foundation

extension PokemonsEntity {
    var formattedWeight: String? {
        weight != 0 ? "\(weight.formattedString()) kg" : nil
    }

    var formattedHeight: String? {
        height != 0 ? "\(height.formattedString()) m" : nil
    }

    var formattedPhysicalInfo: String {
        [formattedWeight, formattedHeight]
            .compactMap { $0 }
            .joined(separator: ", ")
    }
}
