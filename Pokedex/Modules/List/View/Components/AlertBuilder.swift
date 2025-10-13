//
//  AlertBuilder.swift
//  Pokedex
//
//  Created by JoseAlvarez on 10/13/25.
//

import SwiftUI

struct AlertBuilder {
    static func initialLoadAlert(
        fetchError: Error,
        retryAction: @escaping () -> Void,
        cancelAction: @escaping () -> Void
    ) -> Alert {
        Alert(
            title: Text("Connectivity Issue"),
            message: Text(PokemonError.connectivityIssue.localizedDescription),
            primaryButton: .default(Text("Try Again"), action: retryAction),
            secondaryButton: .cancel(cancelAction)
        )
    }

    static func searchEmptyAlert(
        dismissAction: @escaping () -> Void
    ) -> Alert {
        Alert(
            title: Text("There was an Error"),
            message: Text(PokemonError.searchEmpty.localizedDescription),
            dismissButton: .default(Text("OK"), action: dismissAction)
        )
    }
}
