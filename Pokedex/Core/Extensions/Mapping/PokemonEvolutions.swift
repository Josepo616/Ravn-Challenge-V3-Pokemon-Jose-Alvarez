//
//  Evolution.swift
//  Pokedex
//
//  Created by JoseAlvarez on 10/14/25.
//

import Foundation

extension NextEvolutionEntity {
    func toNextEvolution() -> NextEvolutionUIModel {
        return NextEvolutionUIModel(
            name: self.name,
            url: self.url,
            triggerName: ""
        )
    }
}
