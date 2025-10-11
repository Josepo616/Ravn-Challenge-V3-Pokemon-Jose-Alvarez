//
//  PokedexTests.swift
//  PokedexTests
//
//  Created by JoseAlvarez on 10/6/25.
//

import XCTest
import Foundation
import SwiftData
@testable import Pokedex

@MainActor
final class PokedexCoreTests: XCTestCase {

    var container: ModelContainer!
    var session: URLSession!
    var repository: PokemonRepository!

    override func setUpWithError() throws {
        try super.setUpWithError()

        // Setup URLSession using MockURLProtocol (local to this session)
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [MockURLProtocol.self]
        session = URLSession(configuration: config)

        // In-memory SwiftData container for isolation
        let schema = Schema([PokemonsEntity.self, PokedexEntity.self, PokemonTypeEntity.self, NextEvolutionEntity.self])
        let configModel = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)
        container = try ModelContainer(for: schema, configurations: [configModel])

        repository = PokemonRepository(context: container.mainContext, session: session)
    }

    override func tearDownWithError() throws {
        MockURLProtocol.requestHandler = nil
        session = nil
        repository = nil
        container = nil
        try super.tearDownWithError()
    }

    // MARK: - Test: fetchAndStorePokemons success

    func test_fetchAndStorePokemons_success_savesPokemons() async throws {
        // Given: mock responses for list -> detail -> species -> evolution
        MockURLProtocol.requestHandler = { request in
            guard let url = request.url?.absoluteString else {
                throw URLError(.badURL)
            }

            if url.contains("/api/v2/pokemon?") || url.hasSuffix("/api/v2/pokemon") {
                // list endpoint
                let data = TestJSON.pokedexResponseJSON(limit: 50, offset: 0)
                let response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!
                return (response, data)
            } else if url.contains("/pokemon/1/") || url.contains("/pokemon/bulbasaur") || url.contains("/pokemon/1") {
                let data = TestJSON.pokemonDetailJSON()
                let response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!
                return (response, data)
            } else if url.contains("/pokemon-species/1") {
                let data = TestJSON.pokemonSpeciesJSON()
                let response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!
                return (response, data)
            } else if url.contains("/evolution-chain/1") {
                let data = TestJSON.evolutionChainJSON()
                let response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!
                return (response, data)
            }

            let response = HTTPURLResponse(url: request.url!, statusCode: 404, httpVersion: nil, headerFields: nil)!
            return (response, Data())
        }

        // When: fetch and store
        let savedEntities = try await repository.fetchAndStorePokemons(offset: 0, limit: 50)

        // Then: expect entities saved with correct values
        XCTAssertFalse(savedEntities.isEmpty, "Expected at least one PokemonsEntity saved.")
        let first = savedEntities.first!
        XCTAssertEqual(first.name, "bulbasaur")
        XCTAssertEqual(first.id, 1)
        XCTAssertEqual(first.color?.lowercased(), "green")
        XCTAssertEqual(first.types.first?.typeName, "grass")
        XCTAssertTrue(first.flavorText?.contains("strange seed") ?? false)
    }

    // MARK: - Test: fetchPokemon(by:) persists entity

    func test_fetchPokemon_byName_fetchesAndPersistsEntity() async throws {
        // Given: mock responses for fetch by name flow (detail -> species -> evolution)
        MockURLProtocol.requestHandler = { request in
            guard let url = request.url?.absoluteString else {
                throw URLError(.badURL)
            }
            if url.contains("/pokemon/bulbasaur") || url.contains("/pokemon/1/") || url.contains("/pokemon/1") {
                let data = TestJSON.pokemonDetailJSON()
                let response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!
                return (response, data)
            } else if url.contains("/pokemon-species/1") {
                let data = TestJSON.pokemonSpeciesJSON()
                let response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!
                return (response, data)
            } else if url.contains("/evolution-chain/1") {
                let data = TestJSON.evolutionChainJSON()
                let response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!
                return (response, data)
            }

            let response = HTTPURLResponse(url: request.url!, statusCode: 404, httpVersion: nil, headerFields: nil)!
            return (response, Data())
        }

        // When: fetch by name
        let entity = try await repository.fetchPokemon(by: "bulbasaur")

        // Then: entity exists and persisted to context
        XCTAssertNotNil(entity)
        XCTAssertEqual(entity?.name, "bulbasaur")

        // Verify persistence using a FetchDescriptor
        var descriptor = FetchDescriptor<PokemonsEntity>(predicate: #Predicate { $0.name == "bulbasaur" })
        descriptor.fetchLimit = 1
        let results = try container.mainContext.fetch(descriptor)
        XCTAssertEqual(results.first?.id, 1)
    }

    // MARK: - Test: server error -> throws

    func test_fetchAndStorePokemons_serverError_throws() async throws {
        // Given: server returns 500 for any request
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(url: request.url!, statusCode: 500, httpVersion: nil, headerFields: nil)!
            return (response, Data())
        }

        // When / Then: expect an error thrown
        await XCTAssertThrowsErrorAsync {
            _ = try await self.repository.fetchAndStorePokemons(offset: 0, limit: 50)
        }
    }
}

// Helper: async assert throws
extension XCTestCase {
    func XCTAssertThrowsErrorAsync(_ expression: @escaping @Sendable () async throws -> Void,
                                   file: StaticString = #file,
                                   line: UInt = #line) async {
        do {
            try await expression()
            XCTFail("Expected error to be thrown", file: file, line: line)
        } catch {
            // success: an error was thrown
        }
    }
}
