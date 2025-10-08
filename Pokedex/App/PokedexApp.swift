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

    @StateObject private var listVM: ListVM

    init() {
        let context = sharedModelContainer.mainContext
        let repository = PokemonRepository(context: context)
        _listVM = StateObject(wrappedValue: ListVM(repository: repository))
    }

    var body: some Scene {
        WindowGroup {
            MainList(listVM: listVM)
        }
        .modelContainer(sharedModelContainer)
    }
}
