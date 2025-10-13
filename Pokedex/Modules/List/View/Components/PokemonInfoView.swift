//
//  PokemonInfoView.swift
//  Pokedex
//
//  Created by JoseAlvarez on 10/7/25.
//

import SwiftUI

struct PokemonInfoView: View {
    let pokemon: PokemonsEntity

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(pokemon.name.capitalized)
                .font(.headline)
            Text("#\(pokemon.formattedId)")
                .font(.subheadline)
        }
    }
}
