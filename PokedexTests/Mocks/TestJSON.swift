//
//  TestJSON.swift
//  Pokedex
//
//  Created by JoseAlvarez on 10/10/25.
//

import XCTest

enum TestJSON {
    static func pokedexResponseJSON(limit: Int = 50, offset: Int = 0) -> Data {
        let dict: [String: Any] = [
            "count": 1,
            "next": "https://pokeapi.co/api/v2/pokemon?offset=\(offset + limit)&limit=\(limit)",
            "previous": NSNull(),
            "results": [
                ["name": "bulbasaur", "url": "https://pokeapi.co/api/v2/pokemon/1/"]
            ]
        ]
        return try! JSONSerialization.data(withJSONObject: dict, options: [])
    }

    static func pokemonDetailJSON() -> Data {
        let dict: [String: Any] = [
            "id": 1,
            "name": "bulbasaur",
            "sprites": [
                "other": [
                    "home": [
                        "front_default": "https://raw.githubusercontent.com/sprites/default.png",
                        "front_shiny": "https://raw.githubusercontent.com/sprites/shiny.png"
                    ]
                ]
            ],
            "height": 0.7,
            "weight": 6.9,
            "types": [
                [
                    "slot": 1,
                    "type": ["name": "grass", "url": "https://pokeapi.co/api/v2/type/12/"]
                ]
            ],
            "species": ["name": "bulbasaur", "url": "https://pokeapi.co/api/v2/pokemon-species/1/"]
        ]
        return try! JSONSerialization.data(withJSONObject: dict, options: [])
    }

    static func pokemonSpeciesJSON() -> Data {
        let dict: [String: Any] = [
            "color": ["name": "green"],
            "generation": ["name": "generation-i"],
            "evolution_chain": ["url": "https://pokeapi.co/api/v2/evolution-chain/1/"],
            "is_legendary": false,
            "flavor_text_entries": [
                [
                    "flavor_text": "A strange seed was planted on its back at birth.\nThe plant sprouts and grows with this Pokémon.",
                    "language": ["name": "en", "url": "https://pokeapi.co/api/v2/language/9/"]
                ]
            ]
        ]
        return try! JSONSerialization.data(withJSONObject: dict, options: [])
    }

    static func evolutionChainJSON() -> Data {
        let dict: [String: Any] = [
            "id": 1,
            "chain": [
                "species": ["name": "bulbasaur", "url": "https://pokeapi.co/api/v2/pokemon-species/1/"],
                "evolves_to": [
                    [
                        "species": ["name": "ivysaur", "url": "https://pokeapi.co/api/v2/pokemon-species/2/"],
                        "evolves_to": [],
                        "evolution_details": [
                            [
                                "trigger": ["name": "level-up"]
                            ]
                        ]
                    ]
                ],
                "evolution_details": [],
                "trigger": NSNull()
            ]
        ]
        return try! JSONSerialization.data(withJSONObject: dict, options: [])
    }
}
