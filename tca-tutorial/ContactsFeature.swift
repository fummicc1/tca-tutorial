//
//  ContractsFeature.swift
//  tca-tutorial
//
//  Created by Fumiya Tanaka on 2025/01/07.
//

import ComposableArchitecture
import SwiftUI
import Foundation

struct Contact: Equatable, Identifiable {
    let id: UUID
    var name: String
}

@Reducer
struct ContactsFeature {
    @ObservableState
    struct State: Equatable {
        var contacts: IdentifiedArrayOf<Contact> = []
        @Presents var addContact: AddContactFeature.State?
    }
    enum Action {
        case addButtonTapped
        case addContact(PresentationAction<AddContactFeature.Action>)
    }
    
    var body: some ReducerOf<ContactsFeature> {
        Reduce {
            state,
            action in
            switch action {
            case .addButtonTapped:
                state.addContact = .init(
                    contact: Contact(
                        id: UUID(),
                        name: ""
                    )
                )
                return .none
            case .addContact(.presented(.delegate(.saveContact(let contact)))):
                state.contacts.append(contact)
                return .none
            case .addContact:
                return .none
            }
        }
        .ifLet(\.$addContact, action: \.addContact) {
            AddContactFeature()
        }
    }
}

struct ContactsView: View {
    
    @Bindable var store: StoreOf<ContactsFeature>
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(store.contacts) { contact in
                    Text(contact.name)
                }
            }
            .navigationTitle("Contracts")
            .toolbar {
                Button {
                    store.send(.addButtonTapped)
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
        .sheet(item: $store.scope(state: \.addContact, action: \.addContact)) { addContactStore in
            NavigationStack {
                AddContactView(store: addContactStore)
            }
        }
    }
}

#Preview {
    ContactsView(
        store: StoreOf<ContactsFeature>(
            initialState: ContactsFeature.State(
                contacts: [
                    Contact(id: UUID(), name: "Blob"),
                    Contact(id: UUID(), name: "Blob Jr"),
                    Contact(id: UUID(), name: "Blob Sr"),
                ]
            ),
            reducer: {
                ContactsFeature()
            }
        )
    )
}
