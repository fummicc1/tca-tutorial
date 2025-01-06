//
//  NumberFactClient.swift
//  tca-tutorial
//
//  Created by Fumiya Tanaka on 2025/01/06.
//

import ComposableArchitecture
import Foundation

struct NumberFactClient {
    var fetch: (Int) async throws -> String
    
    init(fetch: @escaping (Int) async throws -> String) {
        self.fetch = fetch
    }
}

extension NumberFactClient: DependencyKey {
    static var liveValue: NumberFactClient {
        NumberFactClient { number in
            let (data, _) = try await URLSession.shared
                .data(from: URL(string: "http://numbersapi.com/\(number)")!)
            return String(decoding: data, as: UTF8.self)
        }
    }
}

extension DependencyValues {
    var numberFactClient: NumberFactClient {
        get { self[NumberFactClient.self] }
        set { self[NumberFactClient.self] = newValue }
    }
}
