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

struct Pokemon: Decodable, Hashable {
    let id: Int
    let name: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
    }
}
