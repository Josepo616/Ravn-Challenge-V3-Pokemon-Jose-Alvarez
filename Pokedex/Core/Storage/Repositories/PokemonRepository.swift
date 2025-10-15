import Foundation
import SwiftData

@MainActor
final class PokemonRepository: PokemonRepositoryProtocol {
    let context: ModelContext
    private let networkService: NetworkService
    private let storageService: StorageService
    private var fetchError: Error?

    init(
        context: ModelContext,
        networkService: NetworkService = NetworkService(),
        storageService: StorageService? = nil
    ) {
        self.context = context
        self.networkService = networkService
        self.storageService = storageService ?? StorageService(context: context)
    }

    // MARK: - Public Methods

    func fetchAndStorePokemons(offset: Int = 0, limit: Int = 50) async throws
        -> [PokemonsEntity]
    {
        if let localPokemons = try storageService.fetchLocalPokemons(
            offset: offset,
            limit: limit
        ), localPokemons.count == limit {
            return localPokemons
        }

        let response: PokedexResponse = try await networkService.fetchPokemons(
            offset: offset,
            limit: limit
        )
        try await storageService.processAndSavePokemons(from: response.results)
        try storageService.savePokedexMetadataIfNeeded(response: response)

        return try storageService.fetchLocalPokemons(
            offset: offset,
            limit: limit
        ) ?? []
    }

    func fetchPokedexMetadata() throws -> [PokedexEntity] {
        return try storageService.fetchPokedexMetadata()
    }

    func fetchPokemon(by name: String) async throws -> PokemonsEntity? {
        if let localPokemon = try storageService.fetchLocalPokemon(by: name) {
            return localPokemon
        }
        let pokemon = try await networkService.fetchPokemonDetail(by: name)
        try storageService.savePokemon(pokemon)
        return pokemon
    }

    func getFetchError() -> Error? {
        return fetchError
    }
}

final class NetworkService {
    private let jsonDecoder = JSONDecoder()
    private let session: URLSession

    init(session: URLSession = .shared) {
        self.session = session
    }

    func fetchPokemons(offset: Int, limit: Int) async throws -> PokedexResponse
    {
        let pokemonAPI = PokeApiService(
            endpoint: .pokemon,
            parameters: [.limit: "\(limit)", .offset: "\(offset)"]
        )
        return try await getData(
            from: pokemonAPI.url.absoluteString,
            type: PokedexResponse.self
        )
    }

    func fetchPokemonDetail(by name: String) async throws -> PokemonsEntity {
        let pokemonAPI = PokeApiService(endpoint: .pokemonByName(name))
        let pokemon: PokemonsEntity = try await fetchAndCreatePokemon(
            urlString: pokemonAPI.url.absoluteString,
            name: name
        )
        return pokemon
    }

    private func getData<T: Decodable>(from urlString: String, type: T.Type)
        async throws -> T
    {
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        let (data, response) = try await session.data(from: url)
        guard let httpResponse = response as? HTTPURLResponse,
            (200...299).contains(httpResponse.statusCode)
        else {
            throw URLError(.badServerResponse)
        }
        return try jsonDecoder.decode(T.self, from: data)
    }

    func fetchAndCreatePokemon(urlString: String, name: String)
        async throws -> PokemonsEntity
    {
        let (detail, species, evolution):
            (PokemonDetail, PokemonSpeciesDetail, EvolutionChainResponse) =
                try await fetchLinkedResources(
                    rootURL: urlString,
                    speciesURL: { $0.species.url },
                    evolutionURL: { $0.evolutionChain.url }
                )
        return createPokemonEntity(
            name: name,
            url: urlString,
            detail: detail,
            species: species,
            evolution: evolution
        )
    }

    private func fetchLinkedResources<
        T1: Decodable,
        T2: Decodable,
        T3: Decodable
    >(rootURL: String, speciesURL: (T1) -> String, evolutionURL: (T2) -> String)
        async throws -> (T1, T2, T3)
    {
        let detail: T1 = try await getData(from: rootURL, type: T1.self)
        let species: T2 = try await getData(
            from: speciesURL(detail),
            type: T2.self
        )
        let evolution: T3 = try await getData(
            from: evolutionURL(species),
            type: T3.self
        )
        return (detail, species, evolution)
    }

    private func createPokemonEntity(
        name: String,
        url: String,
        detail: PokemonDetail,
        species: PokemonSpeciesDetail,
        evolution: EvolutionChainResponse
    ) -> PokemonsEntity {
        let nextEvolutions = NextEvolution.getAll(
            from: evolution.chain,
            currentPokemonName: detail.name
        )
        return PokemonsEntity(
            name: name,
            url: url,
            id: detail.id,
            imageURL: detail.imageURL,
            imageShinyURL: detail.imageShinyURL,
            color: species.color.name,
            height: detail.height,
            weight: detail.weight,
            generation: species.generation.name,
            flavorText: species.englishFlavorText,
            evolutionTrigger: nextEvolutions.first?.triggerName ?? "",
            isLegendary: species.isLegendary,
            types: detail.types,
            nextEvolution: nextEvolutions
        )
    }
}

final class StorageService {
    private let context: ModelContext

    init(context: ModelContext) {
        self.context = context
    }

    func fetchLocalPokemons(offset: Int, limit: Int) throws -> [PokemonsEntity]?
    {
        let descriptor = FetchDescriptor<PokemonsEntity>(
            predicate: #Predicate { $0.id > offset && $0.id <= offset + limit }
        )
        let pokemons = try context.fetch(descriptor)
        return pokemons.isEmpty ? nil : sortedPokemonsById(pokemons)
    }

    func fetchLocalPokemon(by name: String) throws -> PokemonsEntity? {
        var descriptor = FetchDescriptor<PokemonsEntity>(
            predicate: #Predicate { $0.name == name }
        )
        descriptor.fetchLimit = 1
        return try context.fetch(descriptor).first
    }

    func fetchPokedexMetadata() throws -> [PokedexEntity] {
        let descriptor = FetchDescriptor<PokedexEntity>()
        return try context.fetch(descriptor)
    }

    func processAndSavePokemons(from results: [Pokedex]) async throws {
        var newPokemons: [PokemonsEntity] = []
        for result in results {
            if let existingPokemon = try fetchLocalPokemon(byUrl: result.url) {
                context.delete(existingPokemon)
            }
            let pokemon = try await NetworkService().fetchAndCreatePokemon(
                urlString: result.url,
                name: result.name
            )
            context.insert(pokemon)
            newPokemons.append(pokemon)
            try savePokemon(pokemon)
        }
    }

    func savePokedexMetadataIfNeeded(response: PokedexResponse) throws {
        let existingPokedexCount = try context.fetchCount(
            FetchDescriptor<PokedexEntity>()
        )
        if existingPokedexCount == 0 {
            let pokedex = PokedexEntity(
                count: response.count,
                next: response.next,
                previous: response.previous ?? "nil"
            )
            context.insert(pokedex)
        }
    }

    func savePokemon(_ pokemon: PokemonsEntity) throws {
        context.insert(pokemon)
        try context.save()
    }

    private func fetchLocalPokemon(byUrl url: String) throws -> PokemonsEntity?
    {
        let descriptor = FetchDescriptor<PokemonsEntity>(
            predicate: #Predicate { $0.url == url }
        )
        return try context.fetch(descriptor).first
    }

    private func sortedPokemonsById(_ pokemons: [PokemonsEntity])
        -> [PokemonsEntity]
    {
        return pokemons.sorted { $0.id < $1.id }
    }
}
