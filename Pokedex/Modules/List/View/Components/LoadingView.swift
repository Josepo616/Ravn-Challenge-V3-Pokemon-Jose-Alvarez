//
//  LoadingView.swift
//  Pokedex
//
//  Created by JoseAlvarez on 10/13/25.
//

import SwiftUI

struct LoadingView: View {
    let text: String

    var body: some View {
        VStack {
            Text(text)
                .font(.headline)
                .foregroundColor(.gray)
            ProgressView()
        }
        .padding()
    }
}
