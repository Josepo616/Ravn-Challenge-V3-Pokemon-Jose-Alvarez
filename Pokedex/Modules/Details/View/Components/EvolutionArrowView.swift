//
//  EvolutionArrowView.swift
//  Pokedex
//
//  Created by JoseAlvarez on 10/9/25.
//

import SwiftUI

struct EvolutionArrowView: View {
    let trigger: String

    var body: some View {
        VStack {
            Text(trigger ?? "Unknown".capitalized)
                .font(.system(size: 15))
            Image(systemName: "arrow.right")
                .font(.system(size: 20))
                .foregroundColor(.gray)
                .padding(.horizontal, 4)
        }
    }
}
