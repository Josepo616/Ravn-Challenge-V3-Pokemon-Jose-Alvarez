//
//  PokemonMapper.swift
//  Pokedex
//
//  Created by JoseAlvarez on 10/15/25.
//


struct PokemonMapper {
    static func map(bundle: PokemonDetailBundle) -> PokemonsEntity {
        let nextEvolutions = NextEvolution.getAll(
            from: bundle.evolution.chain,
            currentPokemonName: bundle.detail.name
        )

        return PokemonsEntity(
            name: bundle.name,
            url: bundle.url,
            id: bundle.detail.id,
            imageURL: bundle.detail.imageURL,
            imageShinyURL: bundle.detail.imageShinyURL,
            color: bundle.species.color.name,
            height: bundle.detail.height,
            weight: bundle.detail.weight,
            generation: bundle.species.generation.name,
            flavorText: bundle.species.englishFlavorText,
            evolutionTrigger: nextEvolutions.first?.triggerName ?? "",
            isLegendary: bundle.species.isLegendary,
            types: bundle.detail.types,
            nextEvolution: nextEvolutions
        )
    }
}