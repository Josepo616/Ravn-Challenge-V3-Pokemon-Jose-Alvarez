//
//  PokemonAsyncImage.swift
//  Pokedex
//
//  Created by JoseAlvarez on 10/9/25.
//

import Kingfisher
import SwiftUI

struct PokemonKingFisherImage: View {
    let urlString: String?
    let size: CGFloat
    let placeholderImage: String
    @State private var loadError: Bool = false

    var body: some View {
        Group {
            if let urlString = urlString, let url = URL(string: urlString),
                !urlString.isEmpty
            {
                if !loadError {
                    KFImage.url(url)
                        .onSuccess { _ in
                            self.loadError = false
                        }
                        .onFailure { _ in
                            self.loadError = true
                        }
                        .resizable()
                        .scaledToFit()
                        .frame(width: size, height: size)
                        .onAppear {
                            self.loadError = false
                        }
                } else {
                    Image(placeholderImage)
                        .resizable()
                        .scaledToFit()
                        .frame(width: size, height: size)
                }
            }
        }
        
    }
}
