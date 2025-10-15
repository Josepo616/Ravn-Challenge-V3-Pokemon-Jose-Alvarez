//
//  PokemonEvolutionCard.swift
//  Pokedex
//
//  Created by JoseAlvarez on 10/9/25.
//

import SwiftUI

struct PokemonEvolutionCard: View {
    let pokemon: PokemonUIModel
    let detailVM: DetailVM

    var body: some View {
        VStack(spacing: 6) {
            PokemonKingFisherImage(
                urlString: pokemon.imageURL,
                size: 100,
                placeholderImage: "Error"
            )
            Text(pokemon.name.capitalized)
                .font(.system(size: 15))
            Text("#\(pokemon.formattedId)")
                .font(.system(size: 13))
        }
    }
}
