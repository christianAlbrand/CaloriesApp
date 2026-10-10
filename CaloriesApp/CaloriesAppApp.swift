//
//  CaloriesAppApp.swift
//  CaloriesApp
//
//  Created by Christian-SDGKU on 09/10/26.
//

import SwiftUI
import SwiftData

@main
struct CaloriesAppApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: FoodEntry.self)
    }
}
