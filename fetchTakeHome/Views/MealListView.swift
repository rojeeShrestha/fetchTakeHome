//
//  MealListView.swift
//  Glorify
//
// Created by Rojee Shrestha on 8/19/24.
// Copyright (c) 2024. All rights reserved.
//

import SwiftUI

struct MealListView: View {
    @StateObject private var viewModel = MealListViewModel()
    
    var body: some View {
        NavigationView {
            Group {
                if viewModel.meals.isEmpty {
                    if let errorMessage = viewModel.errorMessage {
                        ContentUnavailableView(label: {
                            Label(errorMessage, systemImage: "exclamationmark.triangle")
                        })
                        .accessibilityLabel(errorMessage)
                    } else {
                        ContentUnavailableView(label: {
                            Label("List of dessert not available. Please come back later.", systemImage: "exclamationmark.triangle")
                        })
                        .accessibilityLabel("List of dessert not available. Please come back later.")
                    }
                } else {
                    List(viewModel.meals) { meal in
                        NavigationLink(destination: MealDetailsView(mealId: meal.id)) {
                            HStack {
                                MealImageView(pictureUrl: meal.thumbnailURL)
                                    .accessibilityHidden(true)
                                
                                Text(meal.name)
                                    .font(.subheadline)
                                    .accessibilityLabel("\(meal.name) meal")
                            }
                            .accessibilityElement(children: .combine)
                        }
                    }
                }
            }
            .navigationTitle("Desserts")
            .navigationBarTitleDisplayMode(.inline)
            .task {
                await viewModel.fetchDesserts(for: "Dessert")
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

#Preview {
    MealListView()
}
