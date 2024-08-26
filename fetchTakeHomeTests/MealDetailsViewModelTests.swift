//
//  MealDetailsViewModelTests.swift
//  Glorify
//
// Created by Rojee Shrestha on 8/25/24.
// Copyright (c) 2024. All rights reserved.
//

import XCTest
@testable import fetchTakeHome

@MainActor
class MealDetailsViewModelTests: XCTestCase {
    var mockNetworkManager: MockNetworkManager!
    var viewModel: MealDetailsViewModel!
    
    override func setUp() {
        super.setUp()
        mockNetworkManager = MockNetworkManager()
        viewModel = MealDetailsViewModel(networkManager: mockNetworkManager)
    }
    
    func testFetchFoodDetail_Success() async {
        let mockNetworkManager = MockNetworkManager()
        mockNetworkManager.mockMealDetailsResult = .success(createMockMealDetails())
        
        let viewModel = MealDetailsViewModel(networkManager: mockNetworkManager)
        
        XCTAssertNil(viewModel.foodDetail)
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertNil(viewModel.errorMessage)
        
        await viewModel.fetchFoodDetail(for: "12345")
        
        XCTAssertNotNil(viewModel.foodDetail)
        XCTAssertEqual(viewModel.foodDetail?.mealName, "Test Meal")
        XCTAssertEqual(viewModel.foodDetail?.numberedInstructions, ["1. Step 1: Do something.", "2. Step 2: Do something else."])
        XCTAssertEqual(viewModel.foodDetail?.ingredientsWithMeasurements.count, 2)
        XCTAssertEqual(viewModel.foodDetail?.ingredientsWithMeasurements[0].ingredient, "Chicken")
        XCTAssertEqual(viewModel.foodDetail?.ingredientsWithMeasurements[0].measurement, "200g")
        XCTAssertEqual(viewModel.foodDetail?.ingredientsWithMeasurements[1].ingredient, "Salt")
        XCTAssertEqual(viewModel.foodDetail?.ingredientsWithMeasurements[1].measurement, "1 tsp")
        XCTAssertNil(viewModel.errorMessage)
        XCTAssertFalse(viewModel.isLoading)
    }
    
    func testFetchFoodDetailFailure() async {
            let mockNetworkManager = MockNetworkManager()
            mockNetworkManager.mockMealDetailsResult = .failure(NetworkError.custom(errorDescription: "Failed to fetch meal details"))

            let viewModel = MealDetailsViewModel(networkManager: mockNetworkManager)

            await viewModel.fetchFoodDetail(for: "12345")

            XCTAssertNil(viewModel.foodDetail)
            XCTAssertNotNil(viewModel.errorMessage)
            XCTAssertEqual(viewModel.errorMessage, "Failed to fetch meal details")
            XCTAssertFalse(viewModel.isLoading)
        }
    
    
    func createMockMealDetails() -> MealDetails {
        let mockJSON = """
        {
            "strMeal": "Test Meal",
            "strInstructions": "Step 1: Do something.\\nStep 2: Do something else.",
            "strIngredient1": "Chicken",
            "strMeasure1": "200g",
            "strIngredient2": "Salt",
            "strMeasure2": "1 tsp"
        }
        """
        
        let jsonData = Data(mockJSON.utf8)
        let decoder = JSONDecoder()
        
        do {
            let mealDetails = try decoder.decode(MealDetails.self, from: jsonData)
            return mealDetails
        } catch {
            fatalError("Failed to create mock MealDetails: \(error)")
        }
    }
}
