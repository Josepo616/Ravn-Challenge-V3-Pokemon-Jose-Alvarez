//
//  PokeApiService.swift
//  Pokedex
//
//  Created by JoseAlvarez on 10/6/25.
//

import Foundation

struct PokeApiService {
    let endpoint: EndpointEnum
    let parameters: [String: String]
    let url: URL

    init(
        endpoint: EndpointEnum,
        parameter: [String: String] = [:],
        baseURL: URL? = URL(string: "https://pokeapi.co/api/v2/")
    ) {
        guard let baseURL else {
            fatalError("Invalid base URL")
        }

        self.endpoint = endpoint
        self.parameters = parameter

        switch endpoint {
        case .pokemon:
            var urlComponents = URLComponents(
                url: baseURL.appendingPathComponent("pokemon"),
                resolvingAgainstBaseURL: true
            )!

            if !parameter.isEmpty {
                urlComponents.queryItems = parameter.map { key, value in
                    URLQueryItem(name: key, value: value)
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
