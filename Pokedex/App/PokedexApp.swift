//
//  PokedexApp.swift
//  Pokedex
//
//  Created by JoseAlvarez on 10/6/25.
//

import SwiftUI
import SwiftData

@main
struct PokedexApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([PokemonsEntity.self, PokedexEntity.self])
        let config = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        return try! ModelContainer(for: schema, configurations: [config])
    }()

    var body: some Scene {
        WindowGroup {
            let context = sharedModelContainer.mainContext
            let repository = PokemonRepository(context: context)
            let viewModel = ListVM(repository: repository)

            ContentView(listVM: viewModel)
        }
        .modelContainer(sharedModelContainer)
    }
}
