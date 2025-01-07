//
//  tca_tutorialApp.swift
//  tca-tutorial
//
//  Created by Fumiya Tanaka on 2024/12/26.
//

import SwiftUI
import ComposableArchitecture

@main
struct tca_tutorialApp: App {
    var body: some Scene {
        WindowGroup {
            ContactsView(
                store: StoreOf<ContactsFeature>(
                    initialState: ContactsFeature.State(),
                    reducer: {
                        ContactsFeature()
                    }
                )
            )
        }
    }
}
