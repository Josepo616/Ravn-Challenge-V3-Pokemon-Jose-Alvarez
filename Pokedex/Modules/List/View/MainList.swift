//
//  ContentView.swift
//  Pokedex
//
//  Created by JoseAlvarez on 10/6/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @StateObject var listVM: ListVM
    
    var body: some View {
        VStack {
            List {
                ForEach(listVM.pokemon, id: \.self) { pokemon in
                    HStack {
                        Text(pokemon.name)
                        Text(pokemon.url)
                        
                    }
                }
                ForEach(listVM.pokedex, id: \.self) { pokedex in
                    HStack {
                        Text("\(pokedex.count)")
                        Text(pokedex.next)
                        Text(pokedex.previous ?? "nil")
                    }
                }
            }
        }
        .task {
            do {
                try await listVM.fetchPokemons()
            } catch {
                print("Error fetching pokemons: \(error)")
            }
        }
    }
}

