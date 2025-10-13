//
//  SpriteTabButton.swift
//  Pokedex
//
//  Created by JoseAlvarez on 10/13/25.
//

import SwiftUI

struct SpriteTabButton: View {
    let title: String
    let index: Int
    @Binding var selectedTab: Int

    var body: some View {
        Button(action: {
            selectedTab = index
        }) {
            Text(title)
                .font(.system(size: 14))
                .foregroundColor(.primary)
                .padding(.horizontal, 50)
                .padding(.vertical, 10)
                .background(
                    selectedTab == index
                        ? Color("TabBarBackground").opacity(0.9)
                        : Color("TabBarBackground").opacity(0.5)
                )
                .cornerRadius(10)
        }
    }
}
