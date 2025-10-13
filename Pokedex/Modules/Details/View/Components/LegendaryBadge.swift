//
//  LegendaryBadge.swift
//  Pokedex
//
//  Created by JoseAlvarez on 10/13/25.
//

import SwiftUI

struct LegendaryBadge: View {
    var body: some View {
        Image("Legendary")
            .resizable()
            .frame(width: 30, height: 30)
            .position(x: UIScreen.main.bounds.width - 40, y: 40)
    }
}
