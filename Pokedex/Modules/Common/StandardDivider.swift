//
//  StandardDivider.swift
//  Pokedex
//
//  Created by JoseAlvarez on 10/13/25.
//

import SwiftUI

struct StandardDivider: View {
    var body: some View {
        Divider()
            .frame(height: 1)
            .background(Color.gray.opacity(0.5))
            .padding(.vertical, 8)
    }
}
