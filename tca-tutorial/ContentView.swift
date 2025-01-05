//
//  ContentView.swift
//  tca-tutorial
//
//  Created by Fumiya Tanaka on 2024/12/26.
//

import ComposableArchitecture
import SwiftUI

struct ContentView: View {
    let store: StoreOf<ContentFeature>
    
    var body: some View {
        VStack {
            Text("\(store.count)")
                .font(.largeTitle)
                .padding()
                .background(Color.black.opacity(0.1))
                .cornerRadius(10)
            HStack {
                Button("-") {
                    store.send(.decrementButtonTapped)
                }
                .font(.largeTitle)
                .padding()
                .background(Color.black.opacity(0.1))
                .cornerRadius(10)
                Button("+") {
                    store.send(.incrementButtonTapped)
                }
                .font(.largeTitle)
                .padding()
                .background(Color.black.opacity(0.1))
                .cornerRadius(10)
            }
        }
    }
}

#Preview {
    ContentView(
        store: StoreOf<ContentFeature>.init(
            initialState: ContentFeature.State(),
            reducer: {
                ContentFeature()
            }
        )
    )
}
