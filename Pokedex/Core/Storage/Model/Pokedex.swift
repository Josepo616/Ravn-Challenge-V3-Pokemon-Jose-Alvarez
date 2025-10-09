//
//  Pokedex.swift
//  Pokedex
//
//  Created by JoseAlvarez on 10/6/25.
//

import Foundation
import SwiftData

struct PokedexResponse: Decodable, Hashable {
    let count: Int
    let next: String
    let previous: String?
    let results: [Pokedex]

    enum CodingKeys: String, CodingKey {
        case count
        case next
        case previous
        case results
    }
}

struct Pokedex: Decodable, Hashable {
    let name: String
    let url: String
}

struct PokemonDetail: Decodable, Hashable {
    let id: Int
    let name: String
    let imageURL: String?
    let imageShinyURL: String?
    let height: Double
    let weight: Double
    let types: [PokemonType]
    let species: PokemonSpecies

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case sprites
        case height
        case weight
        case types
        case species
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let sprites = try container.decode(Sprites.self, forKey: .sprites)
        id = try container.decode(Int.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        imageURL = sprites.other?.home?.frontDefault
        imageShinyURL = sprites.other?.home?.frontShiny
        weight = try container.decode(Double.self, forKey: .weight)
        height = try container.decode(Double.self, forKey: .height)
        types = try container.decode([PokemonType].self, forKey: .types)
        species = try container.decode(PokemonSpecies.self, forKey: .species)
    }
}

struct Sprites: Decodable, Hashable {
    let other: OtherSprites?

    enum CodingKeys: String, CodingKey {
        case other
    }
}

struct OtherSprites: Decodable, Hashable {
    let home: HomeSprites?

    enum CodingKeys: String, CodingKey {
        case home
    }
}

struct HomeSprites: Decodable, Hashable {
    let frontDefault: String?
    let frontShiny: String?

    enum CodingKeys: String, CodingKey {
        case frontDefault = "front_default"
        case frontShiny = "front_shiny"
    }
}

struct PokemonType: Decodable, Hashable {
    let slot: Int
    let type: TypeDetails

    enum CodingKeys: String, CodingKey {
        case slot
        case type
    }
}

struct TypeDetails: Decodable, Hashable {
    let name: String
    let url: String

    enum CodingKeys: String, CodingKey {
        case name
        case url
    }
}

struct PokemonSpecies: Decodable, Hashable {
    let name: String
    let url: String
}

struct PokemonSpeciesDetail: Decodable {
    let color: ColorNameReference
    let evolutionChain: EvolutionChainReference
    let generation: GenerationNameReference
    let flavorTextEntries: [FlavorTextEntry]

    enum CodingKeys: String, CodingKey {
        case color
        case generation
        case evolutionChain = "evolution_chain"
        case flavorTextEntries = "flavor_text_entries"
    }

    var englishFlavorText: String? {
        return flavorTextEntries.first(where: { $0.language.name == "en" })?
            .cleanedFlavorText
    }
}

struct FlavorTextEntry: Decodable {
    let flavorText: String
    let language: FlavorResponse

    enum CodingKeys: String, CodingKey {
        case flavorText = "flavor_text"
        case language
    }

    var cleanedFlavorText: String {
        flavorText
            .replacingOccurrences(of: "\n", with: " ")
            .replacingOccurrences(of: "\r", with: " ")
            .trimmingCharacters(in: .whitespacesAndNewlines)
    }
}

struct FlavorResponse: Decodable {
    let name: String
    let url: String
}

struct ColorNameReference: Decodable {
    let name: String
}

struct GenerationNameReference: Decodable {
    let name: String
}

struct EvolutionChainReference: Decodable {
    let url: String
}

struct EvolutionChainResponse: Decodable {
    let id: Int
    let chain: ChainLink
}

struct ChainLink: Decodable {
    let species: PokemonSpecies
    let evolvesTo: [ChainLink]
    let evolutionDetails: [EvolutionDetail]
    let trigger: Trigger?

    enum CodingKeys: String, CodingKey {
        case species
        case evolvesTo = "evolves_to"
        case evolutionDetails = "evolution_details"
        case trigger
    }
}

struct EvolutionDetail: Decodable {
    let trigger: Trigger?

    enum CodingKeys: String, CodingKey {
        case trigger
    }
}


struct Trigger: Decodable, Hashable {
    let name: String

    enum CodingKeys: String, CodingKey {
        case name
    }
}

struct NextEvolution: Hashable {
    let name: String
    let url: String
    let triggerName: String?

    static func getAll(from chain: ChainLink, currentPokemonName: String)
        -> [NextEvolution]
    {
        
        if chain.species.name == currentPokemonName {

            let baseTriggerName = chain.evolvesTo.first?.evolutionDetails.first?.trigger?.name
            
            return chain.evolvesTo.map { evolutionLink in
                return NextEvolution(
                    name: evolutionLink.species.name,
                    url: evolutionLink.species.url,
                    triggerName: baseTriggerName
                )
            }
        }


        for evolution in chain.evolvesTo {
            let results = getAll(from: evolution, currentPokemonName: currentPokemonName)
            if !results.isEmpty {
                return results
            }
        }

        return []
    }
}
