//
//  Meal.swift
//  Glorify
//
// Created by Rojee Shrestha on 8/19/24.
// Copyright (c) 2024. All rights reserved.
//

import Foundation

struct MealResponse: Codable {
    let meals: [Meal]
}

struct Meal: Identifiable, Codable, Equatable {
    var id: String
    var name: String
    var thumbnailURL: String
    
    enum CodingKeys: String, CodingKey {
        case id = "idMeal"
        case name = "strMeal"
        case thumbnailURL = "strMealThumb"
    }
}
