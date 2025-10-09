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
        ZStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemGray6))
                .padding(.leading, 30)

            HStack(spacing: 12) {
                PokemonAsyncImage(urlString: pokemon.imageURL, size: 60, placeholderText: "No image available")
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
            .padding(.horizontal, 10)
        }
        .frame(maxWidth: .infinity, minHeight: 70, maxHeight: 70)
        .padding(.vertical, 4)
    }
}
