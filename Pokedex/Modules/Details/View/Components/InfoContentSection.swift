//
//  InfoContentSection.swift
//  Pokedex
//
//  Created by JoseAlvarez on 10/8/25.
//

import SwiftUI

struct InfoContentSection: View {
    let viewModel: ListVM
    let pokemon: PokemonsEntity
    let generationFixed: String
    let nextEvolutions: [PokemonsEntity]
    
    var body: some View {
        VStack(spacing: 0.0000001) {
            Text(
                "#\(viewModel.formatID(pokemon.id)) \(pokemon.name.capitalized)"
            )
            .font(.system(size: 28))
            .padding(.bottom, -50)
            TypeTagsSection(pokemon: pokemon)
                .padding(.bottom, -30)
            
            Text(generationFixed)
                .font(.system(size: 17))
                .padding(.bottom, 10)
            
            Text(pokemon.flavorText ?? "No description")
                .font(.system(size: 15))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 20)
                .padding(.bottom, 10)
            
            Text([
                pokemon.weight != 0 ? "Weight: \(formatNumber(pokemon.weight)) kg" : nil,
                pokemon.height != 0 ? "Height: \(formatNumber(pokemon.height)) m" : nil
            ].compactMap { $0 }.joined(separator: ", "))
            
            if !nextEvolutions.isEmpty {
                Divider()
                    .frame(height: 1)
                    .background(Color.gray.opacity(0.5))
                    .padding(.vertical, 8)
                
                EvolutionSection(
                    viewModel: viewModel,
                    pokemon: pokemon,
                    nextEvolutions: nextEvolutions
                )
            }
        }
        .cornerRadius(30, corners: [.topLeft, .topRight])
    }
    
    func formatNumber(_ value: Double) -> String {
        if value == 0 { return "" }
        if value.truncatingRemainder(dividingBy: 1) == 0 {
            return String(format: "%.0f", value)
        } else {
            return String(format: "%.2f", value)
        }
    }

}
