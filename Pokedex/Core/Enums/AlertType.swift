//
//  AlertType.swift
//  Pokedex
//
//  Created by JoseAlvarez on 10/10/25.
//

enum AlertType: Identifiable {
    case initialLoad
    case searchEmpty

    var id: Int {
        switch self {
        case .initialLoad: return 1
        case .searchEmpty: return 2
        }
    }
}
