//
//  Pokedex.swift
//  Pokedex
//
//  Created by JoseAlvarez on 10/6/25.
//

import Foundation
import SwiftData

/// Represents the main response structure from the Pokémon API.
///
/// Contains:
/// - `count`: The total number of Pokémon available.
/// - `next`: URL to the next page of results (if available).
/// - `previous`: URL to the previous page of results (or `nil` if it's the first page).
/// - `results`: An array of `Pokedex` items, each containing the name and full URL of a Pokémon.
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
    let types: [PokemonType]

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case sprites
        case types
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let sprites = try container.decode(Sprites.self, forKey: .sprites)
        id = try container.decode(Int.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        imageURL = sprites.other?.home?.frontDefault
        imageShinyURL = sprites.other?.home?.frontShiny
        types = try container.decode([PokemonType].self, forKey: .types)
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
