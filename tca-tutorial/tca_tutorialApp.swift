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
    let store: StoreOf<AppFeature> = StoreOf<AppFeature>(
        initialState: AppFeature.State()) {
            AppFeature()
        }
    
    var body: some Scene {
        WindowGroup {
            AppView(store: store)
        }
    }
}
