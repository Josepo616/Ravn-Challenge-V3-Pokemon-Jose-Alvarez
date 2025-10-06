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
            fatalError("invalid base url")
        }
        self.endpoint = endpoint
        self.parameters = parameter
        var urlComponents = URLComponents(url: baseURL.appendingPathComponent(endpoint.rawValue), resolvingAgainstBaseURL: true)!
        urlComponents.queryItems = parameter.map { key, value in
            URLQueryItem(name: key, value: value)
        }
        self.url = urlComponents.url ?? baseURL
        print(url)
    }
}
