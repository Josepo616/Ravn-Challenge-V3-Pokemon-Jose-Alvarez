//
//  PokemonDetailView.swift
//  Pokedex
//
//  Created by JoseAlvarez on 10/7/25.
//

import SwiftUI

struct PokemonDetailView: View {
    @ObservedObject var viewModel: ListVM
    let pokemon: PokemonsEntity

    init(pokemon: PokemonsEntity, viewModel: ListVM) {
        self.pokemon = pokemon
        self.viewModel = viewModel
    }

    var body: some View {
        VStack {
            Text(pokemon.name)
                .font(.largeTitle)
            
            if let imageURL = pokemon.imageShinyURL, !imageURL.isEmpty {
                AsyncImage(url: URL(string: imageURL)) { phase in
                    switch phase {
                    case .success(let image):
                        image.resizable().scaledToFit().frame(width: 200, height: 200)
                    case .failure:
                        Text("Failed to load image").foregroundColor(.red)
                    case .empty:
                        ProgressView()
                    @unknown default:
                        EmptyView()
                    }
                }
            } else {
                Text("No image available")
                    .foregroundColor(.gray)
            }
        }
        .onAppear {
            Task {
                // Llamamos al método de actualización antes de mostrar la vista.
                await viewModel.updatePokemonPropertyIfNeeded(pokemon: pokemon)
            }
        }
        .navigationTitle("Pokemon Info")
    }
}
