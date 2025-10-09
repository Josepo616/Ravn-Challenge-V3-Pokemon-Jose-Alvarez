//
//  NextEvolutionEntity.swift
//  Pokedex
//
//  Created by JoseAlvarez on 10/9/25.
//

import Foundation
import SwiftData

@Model
class NextEvolutionEntity: Hashable, Identifiable {
    var id: UUID = UUID()
    var name: String
    var url: String

    @Relationship var pokemon: PokemonsEntity?

    init(name: String, url: String) {
        self.name = name
        self.url = url
    }

    static func == (lhs: NextEvolutionEntity, rhs: NextEvolutionEntity) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
