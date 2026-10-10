//
//  ContentView.swift
//  CaloriesApp
//
//  Created by Christian-SDGKU on 09/10/26.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var context

    @Query(sort: \FoodEntry.date, order: .reverse)
    private var allFoods: [FoodEntry]

    @StateObject private var viewModel = CalorieBalanceViewModel()
    @State private var showingAddFood = false

    private var todayFoods: [FoodEntry] {
        allFoods.filter {
            Calendar.current.isDateInToday($0.date)
        }
    }

    var body: some View {
        NavigationStack {
            List {
                Section("Today's Balance") {
                    LabeledContent(
                        "Calories Consumed",
                        value: "\(viewModel.consumedCalories(from: todayFoods)) kcal"
                    )

                    LabeledContent(
                        "Active Calories Burned",
                        value: "\(Int(viewModel.activeCalories)) kcal"
                    )

                    LabeledContent(
                        "Net Balance",
                        value: "\(Int(viewModel.netBalance(from: todayFoods))) kcal"
                    )

                    if !viewModel.hasHealthData {
                        Text("HealthKit data unavailable. Check permissions or try refreshing.")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }

                    Button("Refresh Health Data") {
                        viewModel.refreshCalories()
                    }
                }

                Section("Today's Food") {
                    if todayFoods.isEmpty {
                        Text("No food logged yet.")
                            .foregroundStyle(.secondary)
                    }

                    ForEach(todayFoods) { food in
                        HStack {
                            VStack(alignment: .leading) {
                                Text(food.name)
                                Text("\(food.calories) kcal")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }

                            Spacer()

                            Button(role: .destructive) {
                                context.delete(food)
                            } label: {
                                Image(systemName: "trash")
                            }
                            .buttonStyle(.borderless)
                        }
                    }
                }
            }
            .navigationTitle("Calorie Balance")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showingAddFood = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddFood) {
                AddFoodView()
            }
            .onAppear {
                viewModel.refreshCalories()
            }
        }
    }
}
