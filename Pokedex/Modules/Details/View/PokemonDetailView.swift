//
//  PokemonDetailView.swift
//  Pokedex
//
//  Created by JoseAlvarez on 10/7/25.
//

import SwiftUI

struct PokemonDetailView: View {
    @StateObject var viewModel: ListVM
    @State private var generationFixed = ""
    @State private var nextEvolution: PokemonsEntity?
    let pokemon: PokemonsEntity

    var body: some View {
        VStack {
            Text(pokemon.name)
                .font(.largeTitle)
            TabView {
                if let imageURL = pokemon.imageURL, !imageURL.isEmpty {
                    pokemonFirstImageSection(for: imageURL)
                        .tag(0)
                }

                if let shinyURL = pokemon.imageShinyURL, !shinyURL.isEmpty {
                    pokemonFirstImageSection(for: shinyURL)
                        .tag(1)
                }
            }
            .tabViewStyle(.page)
            .frame(height: 100)
            Text(generationFixed)
            Text(pokemon.flavorText ?? "No description")
            HStack {
                ForEach(pokemon.types.sorted(by: { $0.slot < $1.slot }), id: \.self) { type in
                    Image(type.typeName.capitalized + "Bar")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                }
            }

            Text("Evolutions")
            
            HStack {
                VStack {
                    pokemonImageSection(for: pokemon)
                    Text(pokemon.name)
                    Text("#\(viewModel.formatID(pokemon.id))")
                }
                .scaleEffect(0.5)

                if let evolution = nextEvolution {
                    VStack {
                        pokemonImageSection(for: evolution)
                        Text(evolution.name)
                        Text("#\(viewModel.formatID(evolution.id))")
                    }
                    .scaleEffect(0.5)
                }
            }
        }
        .background(Color((pokemon.color ?? "").capitalized))
        .onAppear {
            if let generation = pokemon.generation {
                let words = generation.components(separatedBy: "-")
                let capitalizedWords = words.map { $0.capitalized }
                generationFixed = capitalizedWords.joined(separator: " ")
            } else {
                generationFixed = "Unknown"
            }

            Task {
                await loadNextEvolution()
            }
        }
        .navigationTitle("Pokemon Info")
    }

    private func loadNextEvolution() async {
        guard let evolutionName = pokemon.nextEvolutionName, !evolutionName.isEmpty else { return }
        nextEvolution = await viewModel.fetchPokemon(by: evolutionName)
    }
    @ViewBuilder
    private func pokemonFirstImageSection(for urlString: String?) -> some View {
        if let urlString = urlString, !urlString.isEmpty, let url = URL(string: urlString) {
            AsyncImage(url: url) { phase in
                switch phase {
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFit()
                        .frame(width: 200, height: 200)
                case .failure:
                    Text("Failed to load image")
                        .foregroundColor(.red)
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

    @ViewBuilder
    private func pokemonImageSection(for pokemon: PokemonsEntity) -> some View {
        if let imageURL = pokemon.imageURL, !imageURL.isEmpty {
            AsyncImage(url: URL(string: imageURL)) { phase in
                switch phase {
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFit()
                        .frame(width: 200, height: 200)
                case .failure:
                    Text("Failed to load image")
                        .foregroundColor(.red)
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
}
