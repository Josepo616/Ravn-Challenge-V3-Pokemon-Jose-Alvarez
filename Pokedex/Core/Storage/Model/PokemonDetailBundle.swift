//
//  PokemonDetailBundle.swift
//  Pokedex
//
//  Created by JoseAlvarez on 10/15/25.
//


struct PokemonDetailBundle {
    let name: String
    let url: String
    let detail: PokemonDetail
    let species: PokemonSpeciesDetail
    let evolution: EvolutionChainResponse
    let generation: GenerationResponse
    let localizedGenerationNames: [Languages: String]
}
