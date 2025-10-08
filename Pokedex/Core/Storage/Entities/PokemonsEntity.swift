//
//  PokedexEntity.swift
//  Pokedex
//
//  Created by JoseAlvarez on 10/6/25.
//

import Foundation
import SwiftData

@Model
class PokemonsEntity: Hashable {
    var id: Int
    var name: String
    var url: String
    var imageURL: String?
    var imageShinyURL: String?
    var nextEvolutionName: String?
    var nextEvolutionURL: String?
    var color: String?
    var generation: String?
    var flavorText: String?
    @Relationship(deleteRule: .cascade, inverse: \PokemonTypeEntity.pokemon)
    var types: [PokemonTypeEntity] = []

    init(
        name: String,
        url: String,
        id: Int,
        imageURL: String?,
        imageShinyURL: String?,
        color: String,
        generation: String?,
        flavorText: String?,
        types: [PokemonType],
        nextEvolution: NextEvolution?
    ) {
        self.name = name
        self.url = url
        self.id = id
        self.imageURL = imageURL
        self.imageShinyURL = imageShinyURL
        self.color = color
        self.generation = generation
        self.flavorText = flavorText
        self.nextEvolutionName = nextEvolution?.name
        self.nextEvolutionURL = nextEvolution?.url

        self.types = types.map {
            PokemonTypeEntity(
                slot: $0.slot,
                typeName: $0.type.name,
                typeURL: $0.type.url
            )
        }
    }

    static func == (lhs: PokemonsEntity, rhs: PokemonsEntity) -> Bool {
        return lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
