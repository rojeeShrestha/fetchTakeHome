//
//  MealListViewModel.swift
//  Glorify
//
// Created by Rojee Shrestha on 8/19/24.
// Copyright (c) 2024. All rights reserved.
//

import Foundation

@MainActor
class MealListViewModel: ObservableObject {
    @Published var meals: [Meal] = []
    @Published var errorMessage: String?
    @Published var isLoading = false
    
    private let networkManager: NetworkManagerProtocol
    
    init(networkManager: NetworkManagerProtocol = NetworkManager()) {
        self.networkManager = networkManager
    }
    
    
    func fetchDesserts(for category: String) async {
        isLoading = true
        defer { isLoading = false }
        
        let result = await networkManager.fetchMeals(category: category)
        
        switch result {
        case .success(let meals):
            self.meals = meals
            self.errorMessage = nil
        case .failure(let error):
            self.errorMessage = error.localizedDescription
        }
    }
}
