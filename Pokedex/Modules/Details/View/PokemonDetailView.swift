//
//  PokemonDetailView.swift
//  Pokedex
//
//  Created by JoseAlvarez on 10/7/25.
//

import SwiftUI

struct PokemonDetailView: View {
    @ObservedObject var detailVM: DetailVM
    @State private var nextEvolutions: [PokemonUIModel] = []
    @State private var selectedTab = 0
    let pokemon: PokemonUIModel
    @Binding var language: Languages

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack {
                ZStack {
                    Color(pokemon.color.capitalized)
                        .frame(height: 300)
                        .ignoresSafeArea(edges: .top)

                    ImageHeaderSection(
                        selectedTab: $selectedTab,
                        pokemon: pokemon,
                        language: $language
                    )
                }

                InfoContentSection(
                    detailVM: detailVM,
                    pokemon: pokemon,
                    nextEvolutions: nextEvolutions,
                    language: $language
                )
            }
        }
        .navigationTitle(
            MappingLanguages(language: language).detailTitlteString()
        )
        .navigationBarTitleDisplayMode(.inline)
        .task {
            nextEvolutions = await detailVM.fetchNextEvolutions(for: pokemon)
        }
    }
}
