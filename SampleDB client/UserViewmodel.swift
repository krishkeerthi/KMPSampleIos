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
    @Published var isLoading: Bool = false
    
    @Published var state = UserState(isLoading: true, users: [], errorMessage: nil)
    
    private let koinHelper = KoinHelper()

    init() {
        startObserving()
    }

    func startObserving() {
            Task {
                do{
                    for await newState in try koinHelper.getUsersUseCase().invoke() {
                        self.state = newState
                    }
                }
                catch {
                    print(error)
                }
                
            }
        }
    
    @MainActor
    func refresh() {
        Task {
            isLoading = true
            do {
                try await koinHelper.refreshUsers()
            } catch {
                print("Error: \(error)")
            }
            isLoading = false
        }
    }
}

