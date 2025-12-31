//
//  UserViewmodel.swift
//  SampleDB client
//
//  Created by Keerthi K on 24/12/25.
//

import Foundation
import Shared
import Combine

class UserViewModel: ObservableObject {
    @Published var users: [User] = []
    @Published var isLoading: Bool = false
    
    // We still use KoinHelper to resolve the dependency from the KMP side
    private let koinHelper = KoinHelper()

    init() {
        observeUsers()
    }

    @MainActor
    func observeUsers() {
        Task {

            do {
                let useCase = try koinHelper.getUsersUseCase()
                let flow = try useCase.invoke()
                
                for await userList in flow{
                    self.users = userList
                }
            } catch {
                print(error)
            }

        }
    }

    @MainActor
    func refresh() {
        Task {
            isLoading = true
            do {
                // SKIE makes suspend functions feel like real Swift async functions
                try await koinHelper.refreshUsers()
            } catch {
                print("Error: \(error)")
            }
            isLoading = false
        }
    }
}

