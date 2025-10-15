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
    @StateObject private var detailVM: DetailVM

    init() {
        let context = sharedModelContainer.mainContext
        let repository = PokemonRepository(context: context)
        let listVM = ListVM(repository: repository)
        let detailVM = DetailVM(listVM: listVM)

        _listVM = StateObject(wrappedValue: listVM)
        _detailVM = StateObject(wrappedValue: detailVM)
    }

    var body: some Scene {
        WindowGroup {
            MainList(listVM: listVM, detailVM: detailVM, searchQuery: $listVM.searchQuery)
        }
        .modelContainer(sharedModelContainer)
    }
}
