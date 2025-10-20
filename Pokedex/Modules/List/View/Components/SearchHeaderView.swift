//
//  SearchHeaderView.swift
//  Pokedex
//
//  Created by JoseAlvarez on 10/7/25.
//

import SwiftUI

struct SearchHeaderView: View {
    @Binding var searchQuery: String
    @Binding var isSearching: Bool
    @Binding var language: Languages
    let onSearchChange: (String) -> Void
    let onClearSearch: () -> Void

    var body: some View {
        VStack(spacing: 12) {
            HStack {
                if !isSearching {
                    Text(MappingLanguages(language: language).TitleString())
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                LanguageSettingsView(language: $language)
            }
            HStack {
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.gray.opacity(0.2))
                        .frame(height: 35)

                    TextField(
                        MappingLanguages(language: language).SearchBarText(),
                        text: $searchQuery
                    )
                    .foregroundColor(.gray)
                    .padding(.horizontal)
                    .frame(height: 35)
                    .padding(.leading, 30)
                    .overlay(
                        HStack {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(.gray)
                                .padding(.leading, 10)
                            Spacer()

                            if !searchQuery.isEmpty {
                                Button(action: onClearSearch) {
                                    Image(systemName: "xmark.circle.fill")
                                        .foregroundColor(.gray)
                                        .padding(.trailing, 10)
                                }
                            }
                        }
                    )
                    .onChange(of: searchQuery) { _, newValue in
                        onSearchChange(newValue)
                    }
                }
                if !searchQuery.isEmpty {
                    Button(action: onClearSearch) {
                        Text("Cancel")
                            .foregroundColor(.blue)
                            .padding(.trailing, 10)
                    }
                }
            }
        }
        .padding()
    }
}
