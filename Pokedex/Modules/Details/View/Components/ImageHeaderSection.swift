//
//  ImageHeaderSection.swift
//  Pokedex
//
//  Created by JoseAlvarez on 10/8/25.
//

import SwiftUI

struct ImageHeaderSection: View {
    @Binding var selectedTab: Int
    let pokemon: PokemonsEntity

    var body: some View {
        ZStack(alignment: .bottom) {
            TabView(selection: $selectedTab) {
                if let imageURL = pokemon.imageURL, !imageURL.isEmpty {
                    pokemonFirstImageSection(for: imageURL)
                        .tag(0)
                }

                if let shinyURL = pokemon.imageShinyURL, !shinyURL.isEmpty {
                    pokemonFirstImageSection(for: shinyURL)
                        .tag(1)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))

            HStack {
                Button(action: { selectedTab = 0 }) {
                    Text("Default Sprite")
                        .font(.system(size: 14))
                        .foregroundColor(Color.primary)
                        .padding(.horizontal, 50)
                        .padding(.vertical, 10)
                        .background(
                            selectedTab == 0
                                ? Color("TabBarBackground").opacity(0.9)
                                : Color("TabBarBackground").opacity(0.5)
                        )
                        .cornerRadius(10)
                }
                Button(action: { selectedTab = 1 }) {
                    Text("Shiny Sprite")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(Color.primary)
                        .padding(.horizontal, 50)
                        .padding(.vertical, 10)
                        .background(
                            selectedTab == 1
                                ? Color("TabBarBackground").opacity(0.9)
                                : Color("TabBarBackground").opacity(0.5)
                        )
                        .cornerRadius(10)
                }
            }
            .background(Color("TabBarBackground").opacity(0.4))
            .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.gray.opacity(0.4), lineWidth: 1)
            )
            .padding(.bottom, 16)
        }
    }

    @ViewBuilder
    private func pokemonFirstImageSection(for urlString: String?) -> some View {
        if let urlString = urlString, !urlString.isEmpty,
            let url = URL(string: urlString)
        {
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
            .padding(.bottom, 40)

        } else {
            Text("No image available")
                .foregroundColor(.gray)
        }
    }
}
