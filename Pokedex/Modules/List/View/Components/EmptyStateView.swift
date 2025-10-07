//
//  EmptyStateView.swift
//  Pokedex
//
//  Created by JoseAlvarez on 10/7/25.
//

import SwiftUI

struct EmptyStateView: View {
    var body: some View {
        Text("Failed to load data")
            .font(.headline)
            .foregroundColor(.red)
            .frame(maxWidth: .infinity, alignment: .center)
            .listRowInsets(EdgeInsets())
    }
}
