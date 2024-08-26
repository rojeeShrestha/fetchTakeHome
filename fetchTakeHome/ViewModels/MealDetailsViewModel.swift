//
//  MealDetailsViewModel.swift
//  Glorify
//
// Created by Rojee Shrestha on 8/20/24.
// Copyright (c) 2024. All rights reserved.
//

import Foundation

@MainActor
class MealDetailsViewModel: ObservableObject {
    @Published var foodDetail: MealDetails?
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let networkManager: NetworkManagerProtocol
    
    init(networkManager: NetworkManagerProtocol = NetworkManager()) {
        self.networkManager = networkManager
    }
    
    
    func fetchFoodDetail(for id: String) async {
        isLoading = true
        defer { isLoading = false }
        
        let result = await networkManager.fetchMealDetails(mealId: id)
        
        switch result {
        case .success(let foodDetail):
            self.foodDetail = foodDetail
            self.errorMessage = nil
        case .failure(let error):
            self.errorMessage = error.localizedDescription
        }
    }
}
