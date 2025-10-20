//
//  MappingLanguages.swift
//  Pokedex
//
//  Created by JoseAlvarez on 10/20/25.
//

struct MappingLanguages {
    let language: Languages
    var pokemon: PokemonUIModel? = nil

    func TitleString() -> String {
        return L10n.tr("pokemonListTitle", language: language)
    }

    func SearchBarText() -> String {
        return L10n.tr("searchPlaceholder", language: language)

    }

    func DetailTitlteString() -> String {
        return L10n.tr("pokemonDetailTittle", language: language)

    }

    func EvolutionTitleString() -> String {
        return L10n.tr("evolutionTitle", language: language)

    }
    
    func DefaultSpriteString() -> String {
        return L10n.tr("defaultSprite", language: language)

    }
    
    func ShinySpriteString() -> String {
        return L10n.tr("shinySprite", language: language)

    }
    
    func flavorTextString() -> String {
        switch language {
        case .en:
            return pokemon?.englishFlavorText ?? L10n.tr("noDescription", language: language)

        case .es:
            return pokemon?.englishFlavorText ?? L10n.tr("noDescription", language: language)
        }
    }
}
