//
//  AddFoodView.swift
//  CaloriesApp
//
//  Created by Christian-SDGKU on 09/10/26.
//


import SwiftUI
import SwiftData

struct AddFoodView: View {
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss

    @State private var name = ""
    @State private var calories = ""

    var body: some View {
        NavigationStack {
            Form {
                TextField("Food name", text: $name)

                TextField("Calories", text: $calories)
                    .keyboardType(.numberPad)

                Button("Save Food") {
                    guard !name.trimmingCharacters(
                        in: .whitespacesAndNewlines
                    ).isEmpty,
                    let amount = Int(calories),
                    amount > 0 else {
                        return
                    }

                    let food = FoodEntry(
                        name: name.trimmingCharacters(
                            in: .whitespacesAndNewlines
                        ),
                        calories: amount
                    )

                    context.insert(food)
                    dismiss()
                }
                .disabled(
                    name.trimmingCharacters(
                        in: .whitespacesAndNewlines
                    ).isEmpty ||
                    (Int(calories) ?? 0) <= 0
                )
            }
            .navigationTitle("Add Food")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
}