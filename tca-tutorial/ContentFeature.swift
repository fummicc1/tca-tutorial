//
//  ContentFeature.swift
//  tca-tutorial
//
//  Created by Fumiya Tanaka on 2024/12/26.
//

import ComposableArchitecture

@Reducer
struct ContentFeature {
    enum Action {
        case decrementButtonTapped
        case incrementButtonTapped
    }
    
    @ObservableState
    struct State {
        var count: Int = 0
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .decrementButtonTapped:
                state.count -= 1
                return .none
            case .incrementButtonTapped:
                state.count += 1
                return .none
            }
        }
    }
}
