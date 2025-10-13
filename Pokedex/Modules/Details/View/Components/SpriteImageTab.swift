//
//  SpriteImageTab.swift
//  Pokedex
//
//  Created by JoseAlvarez on 10/13/25.
//

import SwiftUI

struct SpriteImageTab: View {
    let url: String
    let tag: Int

    var body: some View {
        PokemonKingFisherImage(
            urlString: url,
            size: 180,
            placeholderImage: "Error"
        )
        .tag(tag)
    }
}
