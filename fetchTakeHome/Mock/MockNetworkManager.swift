//
//  MockNetworkManager.swift
//  Glorify
//
// Created by Rojee Shrestha on 8/25/24.
// Copyright (c) 2024. All rights reserved.
//

import Foundation

class MockNetworkManager: NetworkManagerProtocol {
    var mockMealListResult: Result<[Meal], NetworkError>!
    var mockMealDetailsResult: Result<MealDetails, NetworkError>!

    
    func fetchMeals(category: String) async -> Result<[Meal], NetworkError> {
        return mockMealListResult
    }
        
    func fetchMealDetails(mealId: String) async -> Result<MealDetails, NetworkError> {
        return mockMealDetailsResult
    }
}
