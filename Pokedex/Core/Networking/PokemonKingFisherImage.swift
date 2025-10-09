//
//  PokemonAsyncImage.swift
//  Pokedex
//
//  Created by JoseAlvarez on 10/9/25.
//

import SwiftUI
import Kingfisher

struct PokemonKingFisherImage: View {
    let urlString: String?
    let size: CGFloat
    let placeholderText: String
    @State private var loadError: Bool = false
    
    var body: some View {
        Group {
            if let urlString = urlString, let url = URL(string: urlString), !urlString.isEmpty {
                KFImage.url(url)
                    .onSuccess { _ in
                        self.loadError = false
                    }
                    .onFailure { _ in
                        self.loadError = true
                    }
                    .placeholder {
                        if !loadError {
                            ProgressView()
                        }
                    }
                    .resizable()
                    .scaledToFit()
                    .frame(width: size, height: size)
                    .onAppear {
                        self.loadError = false
                    }
            } else {
                Text(placeholderText)
                    .foregroundColor(.gray)
                    .font(.system(size: 10))
            }
            
            if loadError {
                Text(placeholderText)
                    .foregroundColor(.red)
                    .font(.system(size: 12))
            }
        }
    }
}
