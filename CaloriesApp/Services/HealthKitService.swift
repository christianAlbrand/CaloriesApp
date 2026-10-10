//
//  HealthKitService.swift
//  CaloriesApp
//
//  Created by Christian-SDGKU on 09/10/26.
//


import HealthKit

class HealthKitService {
    private let healthStore = HKHealthStore()

    func fetchActiveCalories(completion: @escaping (Double?) -> Void) {
        guard HKHealthStore.isHealthDataAvailable(),
              let energyType = HKObjectType.quantityType(
                forIdentifier: .activeEnergyBurned
              ) else {
            completion(nil)
            return
        }

        healthStore.requestAuthorization(
            toShare: [],
            read: [energyType]
        ) { success, error in
            guard success, error == nil else {
                completion(nil)
                return
            }

            let startOfDay = Calendar.current.startOfDay(for: .now)

            let predicate = HKQuery.predicateForSamples(
                withStart: startOfDay,
                end: .now
            )

            let query = HKStatisticsQuery(
                quantityType: energyType,
                quantitySamplePredicate: predicate,
                options: .cumulativeSum
            ) { _, statistics, error in
                guard error == nil else {
                    completion(nil)
                    return
                }

                let calories = statistics?.sumQuantity()?.doubleValue(
                    for: .kilocalorie()
                ) ?? 0

                completion(calories)
            }

            self.healthStore.execute(query)
        }
    }
}