//
//  ContentFeature.swift
//  tca-tutorial
//
//  Created by Fumiya Tanaka on 2024/12/26.
//

import ComposableArchitecture
import Foundation

@Reducer
struct ContentFeature {
    enum Action {
        case decrementButtonTapped
        case incrementButtonTapped
        case toggleTimerButtonTapped
        case factButtonTapped
        case factResponse(String)
        case timerTick
    }
    
    @ObservableState
    struct State: Equatable {
        var count: Int = 0
        var fact: String?
        var isLoading: Bool = false
        var isTimerRunning: Bool = false
    }
    
    @Dependency(\.continuousClock) var clock
    @Dependency(\.numberFactClient) var numberFactClient
    
    enum CancelID {
        case timer
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .decrementButtonTapped:
                state.count -= 1
                state.fact = nil
                return .none
            case .incrementButtonTapped:
                state.count += 1
                state.fact = nil
                return .none
            case .factButtonTapped:
                state.fact = nil
                state.isLoading = true
                return .run { [count = state.count] send in
                    let fact = try await numberFactClient.fetch(count)
                    await send(.factResponse(fact))
                }
            case .factResponse(let fact):
                state.fact = fact
                state.isLoading = false
                return .none
            case .timerTick:
                state.count += 1
                state.fact = nil
                return .none
            case .toggleTimerButtonTapped:
                state.isTimerRunning.toggle()
                if state.isTimerRunning {
                    return .run { send in
                        for await _ in clock.timer(interval: .seconds(1)) {
                            await send(.timerTick)
                        }
                    }.cancellable(id: CancelID.timer)
                } else {
                    return .cancel(id: CancelID.timer)
                }
            }
        }
    }
}
