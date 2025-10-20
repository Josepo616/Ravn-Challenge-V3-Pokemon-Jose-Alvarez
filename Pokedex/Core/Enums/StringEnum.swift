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

struct MappingLanguages {
    let language: Languages
    var pokemon: PokemonUIModel? = nil

    func TitleString() -> String {
        var message: String
        switch language {
        case .en:
            message = L10n.tr(
                "Title",
                "en",
                fallback: "Pokemon List",
                language: language
            )
        case .es:
            message = L10n.tr(
                "Title",
                "es",
                fallback: "Lista de Pokemones",
                language: language
            )
        }
        return message
    }

    func SearchBarText() -> String {
        var message: String
        switch language {
        case .en:
            message = L10n.tr(
                "Title",
                "en",
                fallback: "Search...",
                language: language
            )
        case .es:
            message = L10n.tr(
                "Title",
                "es",
                fallback: "Buscar...",
                language: language
            )
        }
        return message
    }

    func DetailTitlteString() -> String {
        var message: String
        switch language {
        case .en:
            message = L10n.tr(
                "Title",
                "en",
                fallback: "Pokemon Info",
                language: language
            )
        case .es:
            message = L10n.tr(
                "Title",
                "es",
                fallback: "Información del Pokemon",
                language: language
            )
        }
        return message
    }

    func EvolutionTitleString() -> String {
        var message: String
        switch language {
        case .en:
            message = L10n.tr(
                "Title",
                "en",
                fallback: "Evolutions",
                language: language
            )
        case .es:
            message = L10n.tr(
                "Title",
                "es",
                fallback: "Evoluciones",
                language: language
            )
        }
        return message
    }
    
    func DefaultSpriteString() -> String {
        var message: String
        switch language {
        case .en:
            message = L10n.tr(
                "Title",
                "en",
                fallback: "Default Sprite",
                language: language
            )
        case .es:
            message = L10n.tr(
                "Title",
                "es",
                fallback: "Apariencia Normal",
                language: language
            )
        }
        return message
    }
    
    func ShinySpriteString() -> String {
        var message: String
        switch language {
        case .en:
            message = L10n.tr(
                "Title",
                "en",
                fallback: "Shiny Sprite",
                language: language
            )
        case .es:
            message = L10n.tr(
                "Title",
                "es",
                fallback: "Apariencia Variocolor",
                language: language
            )
        }
        return message
    }
    
    func flavorTextString() -> String {
        var message: String
        switch language {
        case .en:
            message = L10n.tr(
                "Title",
                "en",
                fallback: pokemon?.englishFlavorText ?? "No description",
                language: language
            )
        case .es:
            message = L10n.tr(
                "Title",
                "es",
                fallback: pokemon?.spanishFlavorText ?? "Sin descripción",
                language: language
            )
        }
        return message
    }
}
