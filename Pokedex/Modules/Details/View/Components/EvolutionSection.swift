//
//  EvolutionSection.swift
//  Pokedex
//
//  Created by JoseAlvarez on 10/8/25.
//

import SwiftUI

struct EvolutionSection: View {
    let viewModel: ListVM
    let pokemon: PokemonsEntity
    let nextEvolutions: [PokemonsEntity]

    var body: some View {
        VStack(alignment: .center, spacing: 16) {
            Text("Evolutions")
                .font(.system(size: 22, weight: .bold))
                .padding(.top, 8)

            if nextEvolutions.isEmpty {
                Text("No evolutions available")
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
                    .padding(.top, 8)
            }

            // MARK: - Caso: varias evoluciones
            else if nextEvolutions.count > 1 {
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 20) {
                        ForEach(nextEvolutions, id: \.id) { evolution in
                            HStack(spacing: 16) {
                                VStack(spacing: 6) {
                                    pokemonEvolutionImageSection(for: pokemon)
                                        .frame(width: 100, height: 100)
                                    Text(pokemon.name.capitalized)
                                        .font(.system(size: 15))
                                    Text("#\(viewModel.formatID(pokemon.id))")
                                        .font(.system(size: 13))
                                }

                                VStack {
                                    Text(pokemon.evolutionTrigger ?? "Evolves")
                                        .font(.system(size: 13))
                                        .foregroundColor(.gray)
                                    Image(systemName: "arrow.right")
                                        .font(.system(size: 20))
                                        .foregroundColor(.gray)
                                        .padding(.horizontal, 4)
                                }

                                NavigationLink(
                                    destination: PokemonDetailView(
                                        pokemon: evolution,
                                        viewModel: viewModel
                                    )
                                    .toolbarRole(.editor)
                                ) {
                                    VStack(spacing: 6) {
                                        pokemonEvolutionImageSection(for: evolution)
                                            .frame(width: 100, height: 100)
                                        Text(evolution.name.capitalized)
                                            .font(.system(size: 15))
                                        Text("#\(viewModel.formatID(evolution.id))")
                                            .font(.system(size: 13))
                                    }
                                }
                                .buttonStyle(.plain)
                            }
                        }
                    }
                    .padding(.vertical, 8)
                }
            }

            // MARK: - Caso: solo una evolución
            else if let evolution = nextEvolutions.first {
                HStack(spacing: 16) {
                    VStack(spacing: 6) {
                        pokemonEvolutionImageSection(for: pokemon)
                            .frame(width: 100, height: 100)
                        Text(pokemon.name.capitalized)
                            .font(.system(size: 15))
                        Text("#\(viewModel.formatID(pokemon.id))")
                            .font(.system(size: 13))
                    }

                    VStack {
                        Text(pokemon.evolutionTrigger ?? "Evolves")
                            .font(.system(size: 13))
                            .foregroundColor(.gray)
                        Image(systemName: "arrow.right")
                            .font(.system(size: 20))
                            .foregroundColor(.gray)
                            .padding(.horizontal, 4)
                    }

                    NavigationLink(
                        destination: PokemonDetailView(
                            pokemon: evolution,
                            viewModel: viewModel
                        )
                        .toolbarRole(.editor)
                    ) {
                        VStack(spacing: 6) {
                            pokemonEvolutionImageSection(for: evolution)
                                .frame(width: 100, height: 100)
                            Text(evolution.name.capitalized)
                                .font(.system(size: 15))
                            Text("#\(viewModel.formatID(evolution.id))")
                                .font(.system(size: 13))
                        }
                    }
                    .buttonStyle(.plain)
                }
            }
        }
        .padding(.horizontal)
    }

    // MARK: - Imagen de Pokémon
    @ViewBuilder
    private func pokemonEvolutionImageSection(for pokemon: PokemonsEntity) -> some View {
        if let imageURL = pokemon.imageURL, !imageURL.isEmpty {
            ZStack {
                Ellipse()
                    .fill(Color.black.opacity(0.2))
                    .frame(width: 60, height: 12)
                    .offset(y: 40)

                AsyncImage(url: URL(string: imageURL)) { phase in
                    switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFit()
                            .frame(width: 80, height: 80)
                            .clipShape(Circle())
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
            }
            .frame(width: 87, height: 87)
            .background(
                Circle()
                    .fill(Color.gray.opacity(0.2))
            )
        } else {
            Text("No image available")
                .foregroundColor(.gray)
                .font(.system(size: 10))
        }
    }
}
