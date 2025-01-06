//
//  CounterFeatureTests.swift
//  tca-tutorial
//
//  Created by Fumiya Tanaka on 2025/01/06.
//

import ComposableArchitecture
import Testing

@testable import tca_tutorial

@MainActor
struct CounterFeatureTests {
    @Test
    func basics() async {
        let store = TestStore(
            initialState: ContentFeature.State()
        ) { ContentFeature() }
        await store.send(.incrementButtonTapped) {
            $0.count = 1
        }
        await store.send(.decrementButtonTapped) {
            $0.count = 0
        }
    }
    
    @Test
    func timer() async {
        let clock = TestClock()
        let store = TestStore(
            initialState: ContentFeature.State()
        ) {
            ContentFeature()
        } withDependencies: {
            $0.continuousClock = clock
        }
        await store.send(.toggleTimerButtonTapped) {
            $0.isTimerRunning = true
        }
        await clock.advance(by: .seconds(1))
        await store.receive(\.timerTick) {
            $0.count = 1
        }
        await store.send(.toggleTimerButtonTapped) {
            $0.isTimerRunning = false
        }
    }
    
    @Test
    func numberFact() async {
        let store = TestStore(
            initialState: ContentFeature.State()
        ) {
            ContentFeature()
        } withDependencies: {
            $0.numberFactClient.fetch =  { "\($0) is a good number." }
        }
        await store.send(.factButtonTapped) {
            $0.isLoading = true
        }
        await store.receive(\.factResponse) {
            $0.isLoading = false
            $0.fact = "0 is a good number."
        }
    }
}
