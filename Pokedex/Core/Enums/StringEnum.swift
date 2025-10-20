//
//  StringEnum.swift
//  Pokedex
//
//  Created by JoseAlvarez on 10/16/25.
//

import Foundation

enum Languages: String {
    case en = "english"
    case es = "español"

    var localeIdentifier: String {
        switch self {
        case .en:
            return "en"
        case .es:
            return "es"
        }
    }
}
