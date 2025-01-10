//
//  AddContractFeature.swift
//  tca-tutorial
//
//  Created by Fumiya Tanaka on 2025/01/07.
//

import ComposableArchitecture
import SwiftUI

@Reducer
struct AddContactFeature {
    enum Action {
        case cancelButtonTapped
        case saveButtonTapped
        case delegate(Delegate)
        case setName(String)
        @CasePathable
        enum Delegate: Equatable {
            case cancel
            case saveContact(Contact)
        }
    }
    @ObservableState
    struct State: Equatable {
        var contact: Contact
    }
    @Dependency(\.dismiss) var dismiss
    
    var body: some ReducerOf<AddContactFeature> {
        Reduce { state, action in
            switch action {
            case .saveButtonTapped:
                return .run { [contact = state.contact] send in
                    await send(.delegate(.saveContact(contact)))
                    await dismiss()
                }
            case .cancelButtonTapped:
                return .run { send in
                    await dismiss()
                }
            case .setName(let name):
                state.contact.name = name
                return .none
            case .delegate:
                return .none
            }
        }
    }
}

struct AddContactView: View {
    @Bindable var store: StoreOf<AddContactFeature>
    
    var body: some View {
        Form(
            content: {
                TextField(
                    "Name",
                    text: $store.contact.name.sending(\.setName)
                )
            Button("Save") {
                store.send(.saveButtonTapped)
            }
        })
        .toolbar {
            ToolbarItem {
                Button("Cancel") {
                    store.send(.cancelButtonTapped)
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        AddContactView(
            store: Store(
                initialState: AddContactFeature.State(
                    contact: Contact(
                        id: UUID(),
                        name: "Blob"
                    )
                )
            ) { AddContactFeature()
            }
        )
    }
}
