//
//  FoodEntry.swift
//  CaloriesApp
//
//  Created by Christian-SDGKU on 09/10/26.
//


import Foundation
import SwiftData

@Model
class FoodEntry {
    var name: String
    var calories: Int
    var date: Date

    init(name: String, calories: Int) {
        self.name = name
        self.calories = calories
        self.date = .now
    }
}
