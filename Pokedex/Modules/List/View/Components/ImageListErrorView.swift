//
//  ImageListErrorView.swift
//  Pokedex
//
//  Created by JoseAlvarez on 10/13/25.
//

import SwiftUI

struct ImageListErrorView: View {
    var body: some View {
        Image("Error")
            .resizable()
            .scaledToFit()
            .frame(width: 200, height: 200)
            .offset(y: -30)
    }
}
