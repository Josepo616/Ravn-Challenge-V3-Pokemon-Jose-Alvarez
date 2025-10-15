//
//  NextEvolutionUIModel.swift
//  Pokedex
//
//  Created by JoseAlvarez on 10/15/25.
//

import Foundation

class NextEvolutionUIModel: Hashable, Identifiable {
    var name: String
    var url: String
    var triggerName: String?

    init(name: String, url: String, triggerName: String? = nil) {
        self.name = name
        self.url = url
    }
    
    static func == (lhs: NextEvolutionUIModel, rhs: NextEvolutionUIModel) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
