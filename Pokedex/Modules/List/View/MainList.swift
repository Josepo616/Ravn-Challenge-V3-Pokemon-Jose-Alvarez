//
//  ContentView.swift
//  Pokedex
//
//  Created by JoseAlvarez on 10/6/25.
//

import SwiftData
import SwiftUI

struct ContentView: View {
    @StateObject var listVM: ListVM
    @State private var searchQuery: String = ""
    @State private var isSearching: Bool = false
    @State private var filteredPokemons: [PokemonsEntity] = []

    var body: some View {
        VStack {
            HStack {
                TextField("Search", text: $searchQuery)
                    .padding()
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .onChange(of: searchQuery) { _, newValue in
                        if newValue.isEmpty {
                            filteredPokemons = listVM.pokemon
                            isSearching = false
                        } else {
                            filteredPokemons = listVM.pokemon.filter {
                                $0.name.lowercased().contains(
                                    newValue.lowercased()
                                )

                            }
                            isSearching = true
                        }
                    }

                if !searchQuery.isEmpty {
                    Button(action: {
                        searchQuery = ""
                        filteredPokemons = listVM.pokemon
                        isSearching = false
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.gray)
                            .padding(.trailing)
                    }
                }

                if isSearching {
                    Button(action: {
                        searchQuery = ""
                        filteredPokemons = listVM.pokemon
                        isSearching = false
                    }) {
                        Text("Cancel")
                            .foregroundColor(.blue)
                    }
                }
            }
            .padding()

            List {
                if filteredPokemons.isEmpty {
                    Text("Pokemon not found")
                        .font(.headline)
                        .foregroundColor(.gray)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding()
                } else {
                    ForEach(filteredPokemons, id: \.self) { pokemon in
                        HStack {
                            if let imageURL = pokemon.imageURL,
                                let url = URL(string: imageURL)
                            {
                                AsyncImage(url: url) { image in
                                    image.resizable()
                                        .scaledToFit()
                                        .frame(width: 50, height: 50)
                                } placeholder: {
                                    ProgressView()
                                        .progressViewStyle(
                                            CircularProgressViewStyle()
                                        )
                                }
                            }

                            VStack(alignment: .leading, spacing: 4) {
                                Text(pokemon.name.capitalized)
                                    .font(.headline)
                                Text("#\(listVM.formatID(pokemon.id))")
                                    .font(.caption)
                            }
                            .padding()
                            Spacer()
                            HStack {
                                ForEach(
                                    pokemon.types.sorted(by: {
                                        $0.slot < $1.slot
                                    }),
                                    id: \.self
                                ) { type in
                                    HStack(spacing: 4) {
                                        Image(type.typeName.capitalized)
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 50, height: 50)
                                    }
                                }
                            }
                        }
                    }
                }
            }
            .task {
                await listVM.fetchPokemons()
                filteredPokemons = listVM.pokemon
            }
        }
    }
}
