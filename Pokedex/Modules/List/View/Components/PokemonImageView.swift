//
//  PokemonImageView.swift
//  Pokedex
//
//  Created by JoseAlvarez on 10/7/25.
//

import SwiftUI

struct PokemonImageView: View {
    let imageURL: String?

    var body: some View {
        if let imageURL = imageURL,
            let url = URL(string: imageURL)
        {
            AsyncImage(url: url) { image in
                image
                    .resizable()
                    .scaledToFit()
                    .frame(width: 60, height: 60)
            } placeholder: {
                ProgressView()
                    .frame(width: 60, height: 60)
            }
        } else {
            Color.gray.opacity(0.3)
                .frame(width: 60, height: 60)
                .cornerRadius(8)
        }
    }
}
