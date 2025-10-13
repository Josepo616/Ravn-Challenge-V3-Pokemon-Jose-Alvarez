//
//  View+LastItem.swift
//  Pokedex
//
//  Created by JoseAlvarez on 10/13/25.
//

import SwiftUI

extension View {
    func onLastItemAppear<Item: Equatable>(
        currentItem: Item,
        lastItem: Item?,
        perform action: @escaping () async -> Void
    ) -> some View {
        self.onAppear {
            if let lastItem = lastItem, currentItem == lastItem {
                Task {
                    await action()
                }
            }
        }
    }
}
