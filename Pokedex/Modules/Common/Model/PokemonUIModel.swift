//
//  PokemonUIModel.swift
//  Pokedex
//
//  Created by JoseAlvarez on 10/14/25.
//


import Foundation

struct PokemonUIModel: Identifiable, Equatable, Hashable {
    let id: Int
    let name: String
    let imageURL: String?
    let imageShinyURL: String?
    let types: [PokemonTypeEntity]
    let height: Double
    let weight: Double
    let color: String
    let generation: String
    let isLegendary: Bool
    let flavorText: String?
    let evolutionTrigger: String?
    let nextEvolutions: [NextEvolutionEntity]

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
        self.id = id
        self.name = name
        self.imageURL = imageURL
        self.imageShinyURL = imageShinyURL
        self.types = types.map {
            PokemonTypeEntity(
                slot: $0.slot,
                typeName: $0.type.name,
                typeURL: $0.type.url
            )
        }

        self.height = height
        self.weight = weight
        self.color = color
        self.generation = generation ?? "Unknown"
        self.isLegendary = isLegendary
        self.flavorText = flavorText
        self.evolutionTrigger = evolutionTrigger

        self.nextEvolutions = nextEvolution?.map {
            NextEvolutionEntity(name: $0.name, url: $0.url)
        } ?? []
    }
}
