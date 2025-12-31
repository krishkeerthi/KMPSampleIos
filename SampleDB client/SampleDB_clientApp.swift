//
//  SampleDB_clientApp.swift
//  SampleDB client
//
//  Created by Keerthi K on 24/12/25.
//

import SwiftUI
import Shared

@main
struct SampleDB_clientApp: App {
    init() {
            KoinKt.doInitKoinIos()
        }
    var body: some Scene {
        WindowGroup {
            UserListView()
        }
    }
}
