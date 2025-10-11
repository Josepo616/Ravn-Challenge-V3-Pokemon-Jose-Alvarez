//
//  PokemonError.swift
//  Pokedex
//
//  Created by JoseAlvarez on 10/10/25.
//



enum PokemonError: Error, Equatable {
    case connectivityIssue
    case serverError
    case unknown
    
    case searchEmpty


    var localizedDescription: String {
        switch self {
        case .connectivityIssue:
            return "There is a problem trying to connect.\nPlease check your connectivity."
        case .serverError:
            return "Server error occurred."
        case .unknown:
            return "An unknown error occurred."
        case .searchEmpty:
            return "Failed to Load Data"
        }
    }
}

