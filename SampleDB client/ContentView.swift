//
//  ContentView.swift
//  SampleDB client
//
//  Created by Keerthi K on 24/12/25.
//

import SwiftUI
import Shared


struct UserListScreen: View {
    @StateObject private var viewModel = UserViewModel()

    var body: some View {
        NavigationStack {
            ZStack {
                if !viewModel.state.users.isEmpty {
                    List(viewModel.state.users, id: \.id) { user in
                        UserRow(user: user)
                    }
                    .listStyle(.plain)
                } else if !viewModel.state.isLoading && viewModel.state.errorMessage == nil {
                    ContentUnavailableView("No Users", systemImage: "person.3")
                }

                if viewModel.state.isLoading {
                    ProgressView("Updating...")
                        .padding()
                        .background(.ultraThinMaterial)
                        .cornerRadius(10)
                }

                if let error = viewModel.state.errorMessage, viewModel.state.users.isEmpty {
                    VStack {
                        Image(systemName: "exclamationmark.triangle")
                            .foregroundColor(.red)
                        Text(error)
                            .multilineTextAlignment(.center)
                    }
                    .padding()
                }
            }
            .navigationTitle("Users")
            .task {
                viewModel.startObserving()
            }
//            .refreshable {
//                await viewModel.refresh()
//            }
        }
    }
}

struct UserRow: View {
    let user: User
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(user.name)
                .font(.headline)
            Text(user.email)
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding(.vertical, 4)
    }
}
