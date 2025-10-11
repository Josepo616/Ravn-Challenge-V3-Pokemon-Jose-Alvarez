//
//  PokedexEntity.swift
//  Pokedex
//
//  Created by JoseAlvarez on 10/6/25.
//

import Foundation
import SwiftData

@Model
class PokedexEntity: Hashable {
    var count: Int
    var next: String
    var previous: String?

    init(count: Int, next: String, previous: String) {
        self.count = count
        self.next = next
        self.previous = previous
    }

    static func == (lhs: PokedexEntity, rhs: PokedexEntity) -> Bool {
        return lhs.count == rhs.count && lhs.next == rhs.next
            && lhs.previous == rhs.previous
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(count)
        hasher.combine(next)
        hasher.combine(previous)
    }
}
