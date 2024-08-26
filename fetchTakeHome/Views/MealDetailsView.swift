//
//  MealDetailsView.swift
//  Glorify
//
// Created by Rojee Shrestha on 8/20/24.
// Copyright (c) 2024. All rights reserved.
//

import SwiftUI

struct MealDetailsView: View {
    @StateObject private var viewModel = MealDetailsViewModel()
    let mealId: String
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading) {
                    if let mealDetails = viewModel.foodDetail {
                        Text(mealDetails.mealName)
                            .font(.largeTitle)
                            .bold()
                            .padding(.bottom, 10)
                            .accessibilityLabel("Meal name")
                            .accessibilityValue(mealDetails.mealName)
                        
                        Text("Ingredients & Measurements")
                            .font(.title2)
                            .bold()
                            .padding(.bottom, 8)
                            .accessibilityElement(children: .ignore)
                            .accessibilityAddTraits(.isHeader)
                        
                        
                        ForEach(mealDetails.ingredientsWithMeasurements, id: \.ingredient) { ingredientWithMeasurement in
                            HStack {
                                Text(ingredientWithMeasurement.ingredient.capitalized)
                                    .font(.body)
                                    .accessibilityLabel("Ingredient")
                                    .accessibilityValue(ingredientWithMeasurement.ingredient.capitalized)
                                Spacer()
                                Text(ingredientWithMeasurement.measurement)
                                    .font(.body)
                                    .foregroundColor(.secondary)
                                    .accessibilityLabel("Measurement")
                                    .accessibilityValue(ingredientWithMeasurement.measurement)
                            }
                            .padding(.bottom, 8)
                        }
                        .overlay(
                            Rectangle()
                                .frame(height: 1)
                                .foregroundColor(.gray.opacity(0.5))
                            , alignment: .bottom
                        )
                        
                        Text("Instructions")
                            .font(.title2)
                            .bold()
                            .padding(.top, 10)
                            .padding(.bottom, 8)
                            .accessibilityElement(children: .ignore)
                            .accessibilityAddTraits(.isHeader)
                        
                        VStack(alignment: .leading) {
                            ForEach(mealDetails.numberedInstructions, id: \.self) { instruction in
                                Text(instruction)
                                    .padding(.bottom, 8)
                                    .accessibilityLabel("Instruction")
                                    .accessibilityValue(instruction)
                            }
                        }
                    } else if viewModel.isLoading {
                        ProgressView("Loading Meal Details...")
                    } else if let errorMessage = viewModel.errorMessage {
                        Text(errorMessage)
                            .foregroundColor(.red)
                    }
                }
                .padding(.top, 0)
                .padding(.horizontal, 30)
            }
        }
        .navigationTitle("Meal Detail")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await viewModel.fetchFoodDetail(for: mealId)
        }
    }
}

#Preview {
    MealDetailsView(mealId: "52893")
}
