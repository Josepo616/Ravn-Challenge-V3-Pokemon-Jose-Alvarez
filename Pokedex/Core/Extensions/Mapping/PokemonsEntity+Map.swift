//
//  PokemonsEntityMap.swift
//  Pokedex
//
//  Created by JoseAlvarez on 10/14/25.
//

import Foundation

extension PokemonsEntity {
    func toUIModel() -> PokemonUIModel {
        PokemonUIModel(
            name: name,
            url: url,
            id: id,
            imageURL: imageURL,
            imageShinyURL: imageShinyURL,
            color: color ?? "",
            height: height,
            weight: weight,
            generation: generation,
            englishFlavorText: englishFlavorText,
            spanishFlavorText: spanishFlavorText,
            evolutionTrigger: evolutionTrigger,
            isLegendary: isLegendary,
            generationLocalizedNames: generationLocalizedNames,
            types: types.map { $0.toPokemonType() },
            nextEvolution: nextEvolutions.map { $0.toNextEvolution() }
        )
    }
}
