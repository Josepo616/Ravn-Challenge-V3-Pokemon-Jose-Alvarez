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
    let types: [PokemonTypeUIModel]
    let height: Double
    let weight: Double
    let color: String
    let generation: String
    let isLegendary: Bool
    let generationLocalizedNames: [String: String]
    let englishFlavorText: String?
    let spanishFlavorText: String?
    let evolutionTrigger: String?
    
    let nextEvolutions: [NextEvolutionUIModel]

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
        englishFlavorText: String?,
        spanishFlavorText: String?,
        evolutionTrigger: String?,
        isLegendary: Bool,
        generationLocalizedNames: [String: String] = [:],
        types: [PokemonTypeUIModel],
        nextEvolution: [NextEvolutionUIModel]?
    ) {
        self.id = id
        self.name = name
        self.imageURL = imageURL
        self.imageShinyURL = imageShinyURL
        self.types = types.map {
            PokemonTypeUIModel(
                slot: $0.slot,
                typeName: $0.typeName
            )
        }

        self.height = height
        self.weight = weight
        self.color = color
        self.generation = generation ?? "Unknown"
        self.isLegendary = isLegendary
        self.generationLocalizedNames = generationLocalizedNames
        self.englishFlavorText = englishFlavorText
        self.spanishFlavorText = spanishFlavorText
        self.evolutionTrigger = evolutionTrigger

        self.nextEvolutions = nextEvolution?.map {
            NextEvolutionUIModel(name: $0.name, url: $0.url)
        } ?? []
    }
}
