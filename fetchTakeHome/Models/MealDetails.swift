//
//  MealDetails.swift
//  Glorify
//
// Created by Rojee Shrestha on 8/20/24.
// Copyright (c) 2024. All rights reserved.
//

import Foundation

struct MealDetails: Codable, Equatable {
    var mealName: String
    var mealInstructions: String
    var numberedInstructions: [String]
    var ingredientsWithMeasurements: [IngredientWithMeasurement]
    
    enum CodingKeys: String, CodingKey {
        case mealName = "strMeal"
        case mealInstructions = "strInstructions"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        mealName = try container.decodeIfPresent(String.self, forKey: .mealName) ?? ""
        mealInstructions = try container.decodeIfPresent(String.self, forKey: .mealInstructions) ?? ""
        
        self.numberedInstructions = mealInstructions
            .components(separatedBy: .newlines)
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }
            .enumerated()
            .map { index, step in
                "\(index + 1). \(step)"
            }
        
        var ingredientsWithMeasurements = [IngredientWithMeasurement]()
        let dynamicContainer = try decoder.container(keyedBy: DynamicCodingKeys.self)
        
        for key in dynamicContainer.allKeys {
            if key.stringValue.starts(with: "strIngredient"),
               let ingredient = try dynamicContainer.decodeIfPresent(String.self, forKey: key), !ingredient.isEmpty {
                let index = key.stringValue.replacingOccurrences(of: "strIngredient", with: "")
                let measurementKey = DynamicCodingKeys(stringValue: "strMeasure\(index)")!
                if let measurement = try dynamicContainer.decodeIfPresent(String.self, forKey: measurementKey), !measurement.isEmpty {
                    ingredientsWithMeasurements.append(IngredientWithMeasurement(ingredient: ingredient, measurement: measurement))
                }
            }
        }
        
        self.ingredientsWithMeasurements = ingredientsWithMeasurements
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(mealName, forKey: .mealName)
        try container.encode(mealInstructions, forKey: .mealInstructions)
        
        var dynamicContainer = encoder.container(keyedBy: DynamicCodingKeys.self)
        
        for (index, ingredientWithMeasurement) in ingredientsWithMeasurements.enumerated() {
            let ingredientKey = DynamicCodingKeys(stringValue: "strIngredient\(index + 1)")!
            let measurementKey = DynamicCodingKeys(stringValue: "strMeasure\(index + 1)")!
            
            try dynamicContainer.encode(ingredientWithMeasurement.ingredient, forKey: ingredientKey)
            try dynamicContainer.encode(ingredientWithMeasurement.measurement, forKey: measurementKey)
        }
    }

    static func == (lhs: MealDetails, rhs: MealDetails) -> Bool {
        return lhs.mealName == rhs.mealName &&
            lhs.mealInstructions == rhs.mealInstructions &&
            lhs.numberedInstructions == rhs.numberedInstructions &&
            lhs.ingredientsWithMeasurements == rhs.ingredientsWithMeasurements
    }
}

struct IngredientWithMeasurement: Equatable {
    let ingredient: String
    let measurement: String
}

struct MealDetailResponse: Codable {
    let meals: [MealDetails]
}

// DynamicCodingKeys for dynamic key decoding
struct DynamicCodingKeys: CodingKey {
    var stringValue: String
    
    init?(stringValue: String) {
        self.stringValue = stringValue
    }
    
    var intValue: Int?
    
    init?(intValue: Int) {
        return nil
    }
}
