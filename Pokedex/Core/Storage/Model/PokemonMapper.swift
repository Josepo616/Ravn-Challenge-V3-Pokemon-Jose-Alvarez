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
        
        let generationLocalized = Dictionary(
            uniqueKeysWithValues: bundle.localizedGenerationNames.map { ($0.key.rawValue, $0.value) }
        )

        let selectedGeneration = generationLocalized["english"]

        return PokemonsEntity(
            name: bundle.name,
            url: bundle.url,
            id: bundle.detail.id,
            imageURL: bundle.detail.imageURL,
            imageShinyURL: bundle.detail.imageShinyURL,
            color: bundle.species.color.name,
            height: bundle.detail.height,
            weight: bundle.detail.weight,
            generation: selectedGeneration,
            englishFlavorText: bundle.species.englishFlavorText,
            spanishFlavorText: bundle.species.spanishFlavorText,
            evolutionTrigger: nextEvolutions.first?.triggerName ?? "",
            isLegendary: bundle.species.isLegendary,
            generationLocalizedNames: generationLocalized,
            types: bundle.detail.types,
            nextEvolution: nextEvolutions
        )
    }
}
