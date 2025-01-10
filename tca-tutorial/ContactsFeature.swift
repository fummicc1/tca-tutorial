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
        @Presents var destination: Destination.State?
    }
    enum Action {
        case addButtonTapped
        case destination(PresentationAction<Destination.Action>)
        case deleteButtonTapped(id: Contact.ID)
        
        enum Alert: Equatable {
            case confirmDeletion(id: Contact.ID)
        }
    }
    
    @Dependency(\.uuid) var uuid
    
    var body: some ReducerOf<ContactsFeature> {
        Reduce {
            state,
            action in
            switch action {
            case .addButtonTapped:
                state.destination = .addContact(.init(
                    contact: Contact(
                        id: self.uuid(),
                        name: ""
                    )
                ))
                return .none
            case let .destination(.presented(.addContact(.delegate(.saveContact(contact))))):
                state.contacts.append(contact)
                return .none
            case let .destination(.presented(.alert(.confirmDeletion(id)))):
                state.contacts.remove(id: id)
                return .none
            case .destination:
                return .none
            case let .deleteButtonTapped(id):
                state.destination = .alert(AlertState {
                    TextState("Are you sure?")
                } actions: {
                    ButtonState(role: .destructive, action: .confirmDeletion(id: id)) {
                        TextState("Delete")
                    }
                })
                return .none
            }
        }
        .ifLet(\.$destination, action: \.destination)
    }
}

struct ContactsView: View {
    
    @Bindable var store: StoreOf<ContactsFeature>
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(store.contacts) { contact in
                    HStack {
                        Text(contact.name)
                        Spacer()
                        Button {
                            store.send(.deleteButtonTapped(id: contact.id))
                        } label: {
                            Image(systemName: "trash")
                                .foregroundStyle(Color.red)
                        }
                    }
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
        .sheet(
            item: $store.scope(
                state: \.destination?.addContact,
                action: \.destination.addContact
            )
        ) { addContactStore in
            NavigationStack {
                AddContactView(store: addContactStore)
            }
        }
        .alert($store.scope(state: \.destination?.alert, action: \.destination.alert))
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

extension ContactsFeature {
    @Reducer
    enum Destination {
        case addContact(AddContactFeature)
        case alert(AlertState<ContactsFeature.Action.Alert>)
    }
}
extension ContactsFeature.Destination.State: Equatable {}
