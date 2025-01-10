//
//  ContactsFeatureTests.swift
//  tca-tutorial
//
//  Created by Fumiya Tanaka on 2025/01/09.
//

import ComposableArchitecture
import Foundation
import Testing

@testable import tca_tutorial

@MainActor
struct ContactsFeatureTests {
    @Test
    func addFlow() async {
        let store = TestStore(
            initialState: ContactsFeature.State()
        ) {
            ContactsFeature()
        } withDependencies: {
            $0.uuid = .incrementing
        }
        await store.send(ContactsFeature.Action.addButtonTapped) {
            $0.destination = .addContact(
                AddContactFeature.State(
                    contact: .init(id: UUID(0), name: "")
                )
            )
        }
        await store.send(\.destination.addContact.setName, "Blob Jr.") {
            $0.destination?[keyPath: \.addContact]?.contact.name = "Blob Jr."
        }
        await store.send(\.destination.addContact.saveButtonTapped)
    }
}
