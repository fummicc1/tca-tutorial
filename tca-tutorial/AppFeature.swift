//
//  AppFeature.swift
//  tca-tutorial
//
//  Created by Fumiya Tanaka on 2025/01/06.
//

import ComposableArchitecture
import SwiftUI

struct AppView: View {
    
    let store: StoreOf<AppFeature>
    
    var body: some View {
        TabView {
            Tab("Counter 1", systemImage: "1.circle") {
                ContentView(
                    store: store.scope(
                        state: \.tab1,
                        action: \.tab1
                    )
                )
            }
            Tab("Counter 2", systemImage: "2.circle") {
                ContentView(
                    store: store.scope(
                        state: \.tab2,
                        action: \.tab2
                    )
                )
            }
        }
    }
}

@Reducer
struct AppFeature {
    struct State: Equatable {
        var tab1 = ContentFeature.State()
        var tab2 = ContentFeature.State()
    }
    
    enum Action {
        case tab1(ContentFeature.Action)
        case tab2(ContentFeature.Action)
    }
    
    var body: some ReducerOf<Self> {
        Scope(state: \.tab1, action: \.tab1) {
            ContentFeature()
        }
        Scope(state: \.tab2, action: \.tab2) {
            ContentFeature()
        }
        Reduce { state, action in
            return .none
        }
    }
}
