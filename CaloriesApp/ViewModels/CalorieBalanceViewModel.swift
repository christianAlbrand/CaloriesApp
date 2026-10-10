//
//  CalorieBalanceViewModel.swift
//  CaloriesApp
//
//  Created by Christian-SDGKU on 09/10/26.
//


import Foundation
import HealthKit
import Combine

class CalorieBalanceViewModel: ObservableObject {
    @Published var activeCalories: Double = 0
    @Published var hasHealthData = false

    private let healthService = HealthKitService()

    func refreshCalories() {
        healthService.fetchActiveCalories { [weak self] calories in
            DispatchQueue.main.async {
                self?.hasHealthData = calories != nil
                self?.activeCalories = calories ?? 0
            }
        }
    }

    func consumedCalories(from foods: [FoodEntry]) -> Int {
        foods.reduce(0) { $0 + $1.calories }
    }

    func netBalance(from foods: [FoodEntry]) -> Double {
        Double(consumedCalories(from: foods)) - activeCalories
    }
}
