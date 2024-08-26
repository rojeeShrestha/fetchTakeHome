//
//  NetworkManager.swift
//  Glorify
//
// Created by Rojee Shrestha on 8/19/24.
// Copyright (c) 2024. All rights reserved.
//

import Foundation
protocol NetworkManagerProtocol {
    func fetchMeals(category: String) async -> Result<[Meal], NetworkError>
    func fetchMealDetails(mealId: String) async -> Result<MealDetails, NetworkError>
}


class NetworkManager: NetworkManagerProtocol {
    private let baseURL = "https://themealdb.com/api/json/v1/1/"
    private let decoder = JSONDecoder()
    private var session: URLSessionProtocol
       
    init(session: URLSessionProtocol = URLSession.shared) {
        self.session = session
    }

    func fetchMeals(category: String) async -> Result<[Meal], NetworkError> {
        let urlString = "\(baseURL)filter.php?c=\(category)"
        guard let url = URL(string: urlString) else {
            return .failure(.invalidURL)
        }
        
        do {
            let (data, _) = try await session.data(from: url)
            let mealResponse = try decoder.decode(MealResponse.self, from: data)
            return .success(mealResponse.meals)
        } catch {
            return .failure(.requestFailed)
        }
    }
    
    func fetchMealDetails(mealId: String) async -> Result<MealDetails, NetworkError> {
        let urlString = "\(baseURL)lookup.php?i=\(mealId)"
        guard let url = URL(string: urlString) else {
            return .failure(.invalidURL)
        }
        
        do {
            let (data, _) = try await session.data(from: url)
            let mealDetailResponse = try decoder.decode(MealDetailResponse.self, from: data)
            guard let mealDetail = mealDetailResponse.meals.first else {
                return .failure(.decodingFailed)
            }
            return .success(mealDetail)
        } catch {
            return .failure(.requestFailed)
        }
    }
}
