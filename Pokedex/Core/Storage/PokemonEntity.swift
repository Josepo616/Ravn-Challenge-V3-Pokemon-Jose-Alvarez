//
//  PokedexEntity.swift
//  Pokedex
//
//  Created by JoseAlvarez on 10/6/25.
//

import Foundation
import SwiftData

@Model
class PokemonEntity: Hashable {
    var name: String
    var url: String
    
    var id: Int {
        return Int(url
            .trimmingCharacters(in: CharacterSet(charactersIn: "/"))
            .components(separatedBy: "/")
            .last ?? "0") ?? 0
    }
    
    init(name: String, url: String) {
        self.name = name
        self.url = url
    }

    static func == (lhs: PokemonEntity, rhs: PokemonEntity) -> Bool {
        return lhs.name == rhs.name && lhs.url == rhs.url
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
        hasher.combine(url)
    }
}
