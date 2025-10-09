//
//  Double+String.swift
//  Pokedex
//
//  Created by JoseAlvarez on 10/9/25.
//

import Foundation

extension Double {
    func formattedString() -> String {
        if self == 0 { return "" }
        return self.truncatingRemainder(dividingBy: 1) == 0
            ? String(format: "%.0f", self)
            : String(format: "%.2f", self)
    }
}
