//
//  PokemonAsyncImage.swift
//  Pokedex
//
//  Created by JoseAlvarez on 10/9/25.
//

import SwiftUI

struct PokemonAsyncImage: View {
    let urlString: String?
    let size: CGFloat
    let placeholderText: String

    var body: some View {
        if let urlString = urlString,
           let url = URL(string: urlString), !urlString.isEmpty {
            AsyncImage(url: url) { phase in
                switch phase {
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFit()
                        .frame(width: size, height: size)
                case .failure:
                    Text("Failed to load image")
                        .foregroundColor(.red)
                        .font(.system(size: 10))
                case .empty:
                    ProgressView()
                @unknown default:
                    EmptyView()
                }
            }
        } else {
            Text(placeholderText)
                .foregroundColor(.gray)
                .font(.system(size: 10))
        }
    }
}
