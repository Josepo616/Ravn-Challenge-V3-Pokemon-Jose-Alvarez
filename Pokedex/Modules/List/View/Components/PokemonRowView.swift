//
//  PokemonRowView.swift
//  Pokedex
//
//  Created by JoseAlvarez on 10/7/25.
//

import SwiftUI

struct PokemonRowView: View {
    let pokemon: PokemonsEntity
    let listVM: ListVM

    var body: some View {
        HStack(spacing: 16) {
            PokemonImageView(imageURL: pokemon.imageURL)
            PokemonInfoView(
                name: pokemon.name,
                id: pokemon.id,
                listVM: listVM
            )
            Spacer()
            PokemonTypesView(types: pokemon.types)
        }
        .padding(.vertical, 8)
    }
}
