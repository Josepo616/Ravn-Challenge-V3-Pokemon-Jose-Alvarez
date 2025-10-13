//
//  LegendaryBadge.swift
//  Pokedex
//
//  Created by JoseAlvarez on 10/13/25.
//

import SwiftUI

struct LegendaryBadge: View {
    var body: some View {
        GeometryReader { geometry in
            Image("Legendary")
                .resizable()
                .frame(width: 30, height: 30)
                .position(x: geometry.size.width - 40, y: 40)
        }
    }
}
