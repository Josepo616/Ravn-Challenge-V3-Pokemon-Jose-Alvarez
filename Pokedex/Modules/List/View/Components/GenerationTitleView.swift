//
//  GenerationTitleView.swift
//  Pokedex
//
//  Created by JoseAlvarez on 10/13/25.
//

import SwiftUI

struct GenerationTitleView: View {
    let generation: String
    let listVM: ListVM

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(listVM.fixGeneration(generation))
                .frame(maxWidth: .infinity, alignment: .leading)
            StandardDivider()
        }
    }
}
