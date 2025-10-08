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
            Text(pokemon.nextEvolutionName ?? "No evolves")
            
            if let imageURL = pokemon.imageURL, !imageURL.isEmpty {
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
            HStack {
                ForEach(pokemon.types.sorted(by: { $0.slot < $1.slot }), id: \.self) {
                    type in
                    Image(type.typeName.capitalized + "Bar")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                }
            }
        }
        .background(Color((pokemon.color ?? "").capitalized))
        .onAppear {
            //pokemon.evolvesTo = nil
            Task {
                //await viewModel.updatePokemonPropertiesIfNeeded(pokemon: pokemon)
            }
        }
        .navigationTitle("Pokemon Info")
    }
}
