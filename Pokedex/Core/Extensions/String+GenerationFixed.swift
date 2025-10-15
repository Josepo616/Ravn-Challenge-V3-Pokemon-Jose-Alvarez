//
//  String+GenerationFixed.swift
//  Pokedex
//
//  Created by JoseAlvarez on 10/15/25.
//

import Foundation

extension String {
    func fixGeneration() -> String {
        return
            self
            .components(separatedBy: "-")
            .enumerated()
            .map { index, element in
                return index == 1 ? element.uppercased() : element.capitalized
            }
            .joined(separator: " ")
    }
}
