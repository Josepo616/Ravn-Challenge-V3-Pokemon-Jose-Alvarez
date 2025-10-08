//
//  TypeTagsSection.swift
//  Pokedex
//
//  Created by JoseAlvarez on 10/8/25.
//

import SwiftUI

struct TypeTagsSection: View {
    let pokemon: PokemonsEntity

    var body: some View {
        HStack() {
            ForEach(pokemon.types.sorted(by: { $0.slot < $1.slot }), id: \.self) { type in
                Image(type.typeName.capitalized + "Bar")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 140, height: 140)
            }
        }
    }
}

