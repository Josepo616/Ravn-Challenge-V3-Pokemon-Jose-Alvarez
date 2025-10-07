//
//  TypeIconView.swift
//  Pokedex
//
//  Created by JoseAlvarez on 10/7/25.
//

import SwiftUI

struct TypeIconView: View {
    let typeName: String

    var body: some View {
        Image(typeName.capitalized)
            .resizable()
            .scaledToFit()
            .frame(width: 44, height: 44)
    }
}
