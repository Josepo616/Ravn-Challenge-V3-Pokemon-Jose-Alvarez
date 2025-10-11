//
//  PokemonTypesView.swift
//  Pokedex
//
//  Created by JoseAlvarez on 10/7/25.
//

import SwiftUI

struct PokemonTypesView: View {
    let types: [PokemonTypeEntity]

    var body: some View {
        HStack(spacing: 8) {
            ForEach(types.sorted(by: { $0.slot < $1.slot }), id: \.self) {
                type in
                TypeIconView(typeName: type.typeName)
            }
        }
        .padding(.trailing, 8)
    }
}
