//
//  InfoContentSection.swift
//  Pokedex
//
//  Created by JoseAlvarez on 10/8/25.
//

import SwiftUI

struct InfoContentSection: View {
    let listVM: ListVM
    let pokemon: PokemonsEntity
    let nextEvolutions: [PokemonsEntity]
    
    var body: some View {
        VStack(spacing: 0.0000001) {
            Text(pokemon.displayName)
            .font(.system(size: 28))
            .padding(.bottom, -50)
            
            TypeTagsSection(pokemon: pokemon)
                .padding(.bottom, -30)
            
            Text(listVM.fixGeneration(pokemon.generation ?? "Unknown"))
                .font(.system(size: 17))
                .padding(.bottom, 10)
            
            Text(pokemon.flavorText ?? "No description")
                .font(.system(size: 15))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 20)
                .padding(.bottom, 10)
            
            Text(pokemon.formattedPhysicalInfo)

            if !nextEvolutions.isEmpty {
                StandardDivider()

                EvolutionSection(
                    listVM: listVM,
                    pokemon: pokemon,
                    nextEvolutions: nextEvolutions
                )
            }
        }
        .cornerRadius(30, corners: [.topLeft, .topRight])
    }
}
