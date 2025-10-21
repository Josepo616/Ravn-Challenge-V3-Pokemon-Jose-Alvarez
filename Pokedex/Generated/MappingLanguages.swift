//
//  MappingLanguages.swift
//  Pokedex
//
//  Created by JoseAlvarez on 10/20/25.
//

struct MappingLanguages {
    let language: Languages
    var pokemon: PokemonUIModel? = nil

    func titleString() -> String {
        return L10n.tr("pokemonListTitle", language: language)
    }

    func searchBarText() -> String {
        return L10n.tr("searchPlaceholder", language: language)

    }

    func detailTitlteString() -> String {
        return L10n.tr("pokemonDetailTittle", language: language)

    }

    func evolutionTitleString() -> String {
        return L10n.tr("evolutionTitle", language: language)

    }
    
    func defaultSpriteString() -> String {
        return L10n.tr("defaultSprite", language: language)

    }
    
    func shinySpriteString() -> String {
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
