//
//  PokemonInfoView.swift
//  Pokedex
//
//  Created by JoseAlvarez on 10/7/25.
//

import SwiftUI

struct PokemonInfoView: View {
    let name: String
    let id: Int
    let listVM: ListVM

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(name.capitalized)
                .font(.headline)
            Text("#\(listVM.formatID(id))")
                .font(.subheadline)
                .foregroundColor(.gray)
        }
    }
}
