//
//  Evolution.swift
//  Pokedex
//
//  Created by JoseAlvarez on 10/14/25.
//

import Foundation

extension NextEvolutionEntity {
    func toNextEvolution() -> NextEvolution {
        return NextEvolution(
            name: self.name,
            url: self.url,
            triggerName: ""
        )
    }
}
