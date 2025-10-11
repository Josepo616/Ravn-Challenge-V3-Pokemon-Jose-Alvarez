//
//  PokedexEntity.swift
//  Pokedex
//
//  Created by JoseAlvarez on 10/6/25.
//

import Foundation
import SwiftData

@Model
class PokemonsEntity: Hashable, Identifiable {
    @Attribute(.unique)
    var id: Int
    var name: String
    var url: String

    var height: Double
    var weight: Double

    var color: String?
    var generation: String?
    var flavorText: String?
    var evolutionTrigger: String?

    var imageURL: String?
    var imageShinyURL: String?
    
    var isLegendary: Bool

    @Relationship(deleteRule: .cascade, inverse: \PokemonTypeEntity.pokemon)
    var types: [PokemonTypeEntity] = []

    @Relationship(deleteRule: .cascade, inverse: \NextEvolutionEntity.pokemon)
    var nextEvolutions: [NextEvolutionEntity] = []

    init(
        name: String,
        url: String,
        id: Int,
        imageURL: String?,
        imageShinyURL: String?,
        color: String,
        height: Double,
        weight: Double,
        generation: String?,
        flavorText: String?,
        evolutionTrigger: String?,
        isLegendary: Bool,
        types: [PokemonType],
        nextEvolution: [NextEvolution]?
    ) {
        self.name = name
        self.url = url
        self.id = id
        self.imageURL = imageURL
        self.imageShinyURL = imageShinyURL
        self.color = color
        self.height = height
        self.weight = weight
        self.generation = generation
        self.isLegendary = isLegendary
        self.flavorText = flavorText
        self.evolutionTrigger = evolutionTrigger

        self.types = types.map {
            PokemonTypeEntity(
                slot: $0.slot,
                typeName: $0.type.name,
                typeURL: $0.type.url
            )
        }

        self.nextEvolutions = nextEvolution?.map {
            NextEvolutionEntity(name: $0.name, url: $0.url)
        } ?? []
    }

    static func == (lhs: PokemonsEntity, rhs: PokemonsEntity) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
