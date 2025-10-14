//
//  ImageHeaderSection.swift
//  Pokedex
//
//  Created by JoseAlvarez on 10/8/25.
//

import SwiftUI

struct ImageHeaderSection: View {
    @Binding var selectedTab: Int
    let pokemon: PokemonUIModel

    var body: some View {
        ZStack(alignment: .bottom) {
            TabView(selection: $selectedTab) {
                if let imageURL = pokemon.imageURL, !imageURL.isEmpty {
                    SpriteImageTab(url: imageURL, tag: 0)
                }

                if let shinyURL = pokemon.imageShinyURL, !shinyURL.isEmpty {
                    SpriteImageTab(url: shinyURL, tag: 1)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))

            if pokemon.isLegendary {
                LegendaryBadge()
            }

            HStack {
                SpriteTabButton(
                    selectedTab: $selectedTab,
                    title: "Default Sprite",
                    index: 0
                )
                SpriteTabButton(
                    selectedTab: $selectedTab,
                    title: "Shiny Sprite",
                    index: 1
                )
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
}
