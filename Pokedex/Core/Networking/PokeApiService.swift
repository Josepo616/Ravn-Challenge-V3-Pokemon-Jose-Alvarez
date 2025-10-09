//
//  PokeApiService.swift
//  Pokedex
//
//  Created by JoseAlvarez on 10/6/25.
//

import Foundation

struct PokeApiService {
    let endpoint: EndpointEnum
    let parameters: [ParameterEnum: String]
    let url: URL

    init(
        endpoint: EndpointEnum,
        parameters: [ParameterEnum: String] = [:],
        baseURL: URL? = URL(string: "https://pokeapi.co/api/v2/")
    ) {
        guard let baseURL else {
            fatalError("Invalid base URL")
        }

        self.endpoint = endpoint
        self.parameters = parameters

        switch endpoint {
        case .pokemon:
            var urlComponents = URLComponents(
                url: baseURL.appendingPathComponent("pokemon"),
                resolvingAgainstBaseURL: true
            )!

            if !parameters.isEmpty {
                urlComponents.queryItems = parameters.map { key, value in
                    URLQueryItem(name: key.rawValue, value: value)
                }
            }

            self.url = urlComponents.url ?? baseURL.appendingPathComponent("pokemon")

        case .pokemonByName(let name):
            self.url = baseURL.appendingPathComponent("pokemon/\(name.lowercased())")

        case .species:
            self.url = baseURL.appendingPathComponent("pokemon-species")

        case .evolutionChain:
            self.url = baseURL.appendingPathComponent("evolution-chain")
        }
    }
}
