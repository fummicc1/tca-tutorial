//
//  AppFeatureTests.swift
//  tca-tutorial
//
//  Created by Fumiya Tanaka on 2025/01/06.
//

import ComposableArchitecture
import Testing

@testable import tca_tutorial

@MainActor
struct AppFeatureTests {
    @Test
    func incrementInFirstTab() async {
        let store = TestStore(initialState: AppFeature.State()) {
            AppFeature()
        }
        await store.send(.tab1(.incrementButtonTapped)) {
            $0.tab1.count = 1
        }
    }
}
