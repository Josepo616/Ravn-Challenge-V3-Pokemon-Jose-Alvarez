//
//  PokedexListVMTests.swift
//  Pokedex
//
//  Created by JoseAlvarez on 10/10/25.
//

// PokedexListVMUnitTests.swift
// PokedexTests
//
// Created by ChatGPT on 2025-10-10

import XCTest
import Foundation
@testable import Pokedex


// MARK: - Tests for ListVM

@MainActor
final class PokedexListVMUnitTests: XCTestCase {

    var fakeRepo: FakeRepository!
    var sut: ListVM! // system under test

    override func setUpWithError() throws {
        try super.setUpWithError()
        fakeRepo = FakeRepository()
        sut = ListVM(repository: fakeRepo)
    }

    override func tearDownWithError() throws {
        sut = nil
        fakeRepo = nil
        try super.tearDownWithError()
    }

    // MARK: - fetchPokemons success

    func testFetchPokemonsGivenEmptyPokemonWhenRepositoryReturnsListThenPopulatePokemonAndFilteredPokemons() async throws {
        // Given
        // Two pokemons returned for offset 0
        let p1 = makePokemon(name: "bulbasaur", id: 1)
        let p2 = makePokemon(name: "charmander", id: 4)
        fakeRepo.pokemonsByOffset[0] = [p1, p2]
        fakeRepo.pokedexMetadataToReturn = [PokedexEntity(count: 2, next: "next", previous: "prev")]

        // When
        try await sut.fetchPokemons()

        // Then
        XCTAssertEqual(sut.filteredPokemons.count, 2, "Filtered pokemons should be populated with repository results")
        XCTAssertEqual(sut.filteredPokemons.map { $0.name }, ["bulbasaur", "charmander"])
        XCTAssertFalse(sut.isFetchingData, "isFetchingData should be false after successful fetch")
        XCTAssertEqual(fakeRepo.fetchAndStoreCallCount, 1, "Repo.fetchAndStorePokemons should be called once")
    }

    // MARK: - fetchPokemons early return (no network call if pokemon already exists)

    func testFetchPokemonsGivenPokemonAlreadyLoadedThenReturnsEarlyWithoutCallingRepository() async throws {
        // Given: pre-populate sut.pokemon by simulating initial fetch
        let initial = makePokemon(name: "pikachu", id: 25)
        // We can't assign to private(set) directly; simulate via repository call
        fakeRepo.pokemonsByOffset[0] = [initial]
        try await sut.fetchPokemons()
        XCTAssertEqual(sut.filteredPokemons.count, 1)

        // Reset counter then call fetchPokemons again
        fakeRepo.fetchAndStoreCallCount = 0

        // When: call fetchPokemons again
        try await sut.fetchPokemons()

        // Then: repository should not be called again
        XCTAssertEqual(fakeRepo.fetchAndStoreCallCount, 0, "Should not call repository when pokemon already loaded")
    }

    // MARK: - retryFetchPokemons maps connectivity error

    func testRetryFetchPokemonsGivenRepositoryThrowsURLErrorWhenCalledThenFetchErrorSetToConnectivityIssue() async throws {
        // Given
        fakeRepo.throwOnFetchAndStore = URLError(.notConnectedToInternet)

        // When
        await sut.retryFetchPokemons()

        // Then
        XCTAssertEqual(sut.fetchError, .connectivityIssue, "retryFetchPokemons should set fetchError to connectivityIssue on URLError.notConnectedToInternet")
    }

    // MARK: - formatID formatting

    func testFormatIDFormatsToFourDigits() {
        // Given / When / Then
        XCTAssertEqual(sut.formatID(1), "0001")
        XCTAssertEqual(sut.formatID(25), "0025")
        XCTAssertEqual(sut.formatID(1234), "1234")
        XCTAssertEqual(sut.formatID(12345), "12345") // beyond 4 digits still prints full number
    }

    // MARK: - handleSearchChange and clearSearch

    func testHandleSearchChangeGivenEmptyQueryThenResetsFilteredPokemons() async throws {
        // Given: populate pokemons
        let p1 = makePokemon(name: "aaa", id: 1)
        fakeRepo.pokemonsByOffset[0] = [p1]
        try await sut.fetchPokemons()
        // Start with non-empty filtered (already true)

        // When: search empty
        sut.handleSearchChange("")

        // Then
        // Immediately should set filteredPokemons to pokemon and isSearching false
        XCTAssertEqual(sut.filteredPokemons.count, 1)
        XCTAssertFalse(sut.isSearching)
    }

    func testHandleSearchChangeGivenNonEmptyQueryThenFiltersAfterDelay() async throws {
        // Given
        let p1 = makePokemon(name: "bulbasaur", id: 1)
        let p2 = makePokemon(name: "charmander", id: 4)
        fakeRepo.pokemonsByOffset[0] = [p1, p2]
        try await sut.fetchPokemons()

        // When
        sut.handleSearchChange("char")

        // Then: after 0.2s debounce the filteredPokemons should be updated
        try await Task.sleep(nanoseconds: 300 * 1_000_000) // 300ms
        XCTAssertEqual(sut.filteredPokemons.count, 1)
        XCTAssertEqual(sut.filteredPokemons.first?.name, "charmander")
        XCTAssertFalse(sut.isSearching)
    }

    func testClearSearchResetsToAllPokemonsAndClearsQuery() async throws {
        // Given
        let p1 = makePokemon(name: "bulbasaur", id: 1)
        fakeRepo.pokemonsByOffset[0] = [p1]
        try await sut.fetchPokemons()
        sut.handleSearchChange("b")
        try await Task.sleep(nanoseconds: 300 * 1_000_000)

        // Pre-check
        XCTAssertEqual(sut.searchQuery, "b")

        // When
        sut.clearSearch()

        // Then
        XCTAssertEqual(sut.searchQuery, "")
        XCTAssertFalse(sut.isSearching)
        XCTAssertEqual(sut.filteredPokemons.count, 1)
    }

    // MARK: - fetchPokemon(by:) success and failure

    func testFetchPokemonByNameGivenRepositoryHasPokemonThenReturnsEntity() async throws {
        // Given
        let bulba = makePokemon(name: "bulbasaur", id: 1)
        fakeRepo.pokemonByNameToReturn["bulbasaur"] = bulba

        // When
        let result = await sut.fetchPokemon(by: "bulbasaur")

        // Then
        XCTAssertNotNil(result)
        XCTAssertEqual(result?.name, "bulbasaur")
        XCTAssertEqual(fakeRepo.fetchPokemonByNameCallCount, 1)
    }

    func testFetchPokemonByNameGivenRepositoryThrowsThenReturnsNil() async throws {
        // Given
        fakeRepo.throwOnFetchPokemonByName = URLError(.notConnectedToInternet)

        // When
        let result = await sut.fetchPokemon(by: "missing")

        // Then
        XCTAssertNil(result)
        XCTAssertEqual(fakeRepo.fetchPokemonByNameCallCount, 1)
    }

    // MARK: - loadMorePokemons behavior

    func testLoadMorePokemonsDoesNothingWhenIsFetchingMoreTrue() async throws {
        // Given
        sut.isFetchingMore = true
        fakeRepo.pokemonsByOffset[50] = [ makePokemon(name: "mew", id: 150) ]

        // When
        await sut.loadMorePokemons()

        // Then
        XCTAssertEqual(fakeRepo.fetchAndStoreCallCount, 0, "Should not call repository when isFetchingMore is true")
    }

    func testLoadMorePokemonsDoesNothingWhenSearchActiveOrQueryNotEmpty() async throws {
        // Given
        sut.isSearching = true
        sut.searchQuery = "a"
        fakeRepo.pokemonsByOffset[50] = [ makePokemon(name: "mew", id: 150) ]

        // When
        await sut.loadMorePokemons()

        // Then
        XCTAssertEqual(fakeRepo.fetchAndStoreCallCount, 0, "Should not call repository when searching or query not empty")
    }

    func testLoadMorePokemonsAppendsOnlyUniqueNewPokemonsAndTogglesIsFetchingMore() async throws {
        // Given: initial dataset at offset 0
        let p1 = makePokemon(name: "bulbasaur", id: 1)
        fakeRepo.pokemonsByOffset[0] = [p1]
        print("Initial Pokemon List: \(sut.pokemon)") // Debug print
        try await sut.fetchPokemons()
        XCTAssertEqual(sut.pokemon.count, 1)
        
        // New page returns two pokemons, one duplicate (id 1) and one new (id 2)
        let duplicate = makePokemon(name: "bulbasaur", id: 1)
        let newOne = makePokemon(name: "ivysaur", id: 2)
        fakeRepo.pokemonsByOffset[50] = [duplicate, newOne]
        
        // Pre-check isFetchingMore false
        XCTAssertFalse(sut.isFetchingMore)
        print("Before loadMore, isFetchingMore: \(sut.isFetchingMore)") // Debug print
        
        // When
        await sut.loadMorePokemons()
        
        // Then: isFetchingMore should have toggled (false after defer)
        print("After loadMore, isFetchingMore: \(sut.isFetchingMore)") // Debug print
        XCTAssertFalse(sut.isFetchingMore)
        
        // offset should have increased by limit (50)
        print("Current Offset: \(sut.offset)") // Debug print
        XCTAssertEqual(sut.offset, 50)
        
        // Only new pokemon appended
        let containsNewPokemon = sut.pokemon.contains(where: { $0.id == 2 })
        print("Contains new pokemon with id 2: \(containsNewPokemon)") // Debug print
        XCTAssertTrue(containsNewPokemon)
        XCTAssertEqual(sut.pokemon.count, 2)
        
        print("fetchAndStoreCallCount: \(fakeRepo.fetchAndStoreCallCount)") // Debug print
        XCTAssertEqual(fakeRepo.fetchAndStoreCallCount, 2, "fetchAndStore called once for initial fetch and once for loadMore")
    }


    func testLoadMorePokemonsWhenRepositoryThrowsErrorIsHandledAndIsFetchingMoreReset() async throws {
        // Given: initial dataset
        fakeRepo.pokemonsByOffset[0] = [ makePokemon(name: "a", id: 1) ]
        print("Initial Pokemon List: \(sut.pokemon)") // Debug print
        try await sut.fetchPokemons()
        fakeRepo.throwOnFetchAndStore = URLError(.notConnectedToInternet)
        
        // When
        await sut.loadMorePokemons()
        
        // Then: should have attempted call but not crash; isFetchingMore reset to false
        print("After loadMore, isFetchingMore: \(sut.isFetchingMore)") // Debug print
        XCTAssertFalse(sut.isFetchingMore)
        
        print("fetchAndStoreCallCount: \(fakeRepo.fetchAndStoreCallCount)") // Debug print
        XCTAssertEqual(fakeRepo.fetchAndStoreCallCount, 2) // initial + failed loadMore
    }

}

// MARK: - Helpers for creating test PokemonsEntity

private func makePokemon(name: String, id: Int) -> PokemonsEntity {
    return PokemonsEntity(
        name: name,
        url: "https://pokeapi.co/api/v2/pokemon/\(id)/",
        id: id,
        imageURL: nil,
        imageShinyURL: nil,
        color: "color",
        height: 0,
        weight: 0,
        generation: nil,
        flavorText: nil,
        evolutionTrigger: nil,
        types: [],
        nextEvolution: nil
    )
}
