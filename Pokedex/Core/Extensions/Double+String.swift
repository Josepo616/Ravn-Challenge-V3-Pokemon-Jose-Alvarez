//
//  Double+String.swift
//  Pokedex
//
//  Created by JoseAlvarez on 10/9/25.
//

import Foundation

extension Double {
    func formattedString() -> String {
        let number = self / 10
        if number == 0 { return "" }

        return number.truncatingRemainder(dividingBy: 1) == 0
            ? String(format: "%.0f", number)
            : String(format: "%.1f", number)
    }
}
