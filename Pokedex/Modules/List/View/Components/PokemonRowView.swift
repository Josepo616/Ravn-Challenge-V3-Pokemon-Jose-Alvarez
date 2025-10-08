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
        HStack(spacing: 12) {
            PokemonImageView(imageURL: pokemon.imageURL)
            PokemonInfoView(
                name: pokemon.name,
                id: pokemon.id,
                listVM: listVM
            )
            .padding(.leading, 4)
            Spacer()
            PokemonTypesView(types: pokemon.types)
        }
        .padding(.vertical, 5)
        .padding(.horizontal, 5)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .offset(x: 30)
                .size(width: 330, height: 70)
                .fill(Color(.systemGray6))
        )
        .padding(.vertical, 4)
    }
}
