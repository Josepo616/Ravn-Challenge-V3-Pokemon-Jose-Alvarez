//
//  LanguageSettingsView.swift
//  Pokedex
//
//  Created by JoseAlvarez on 10/20/25.
//

import SwiftUI

struct LanguageSettingsView: View {
    @Binding var language: Languages
    
    var body: some View {
        Menu {
            Button(action: {
                language = .en
            }) {
                language == .en ? Text("English") : Text("Ingles")
            }
            Button(action: {
                language = .es
            }) {
                language == .en ? Text("Spanish") : Text("Español")
            }
        } label: {
            Image(systemName: "gear")
                .font(.title)
                .foregroundColor(.secondary)
        }
    }
}
