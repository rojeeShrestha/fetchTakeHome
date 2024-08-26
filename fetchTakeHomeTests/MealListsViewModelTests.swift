//
//  MealListsViewModelTests.swift
//  Glorify
//
// Created by Rojee Shrestha on 8/25/24.
// Copyright (c) 2024. All rights reserved.
//

import XCTest
@testable import fetchTakeHome

@MainActor
class MealListViewModelTests: XCTestCase {
    var viewModel: MealListViewModel!
    var mockNetworkManager: MockNetworkManager!

    override func setUp() {
        super.setUp()
        
        mockNetworkManager = MockNetworkManager()
        
        Task {
            viewModel = MealListViewModel(networkManager: mockNetworkManager)
        }
    }

    func testFetchDessertsSuccess() async {
        let expectedMeals = [Meal(id: "1", name: "Test Meal", thumbnailURL: "test_thumbnail")]
        mockNetworkManager.mockMealListResult = .success(expectedMeals)
        
        await Task.yield()
        
        await viewModel.fetchDesserts(for: "Dessert")
        
        XCTAssertEqual(viewModel.meals, expectedMeals)
        XCTAssertNil(viewModel.errorMessage)
    }

    func testFetchDessertsFailure() async {
        mockNetworkManager.mockMealListResult = .failure(NetworkError.requestFailed)
        
        await Task.yield()
        
        await viewModel.fetchDesserts(for: "Dessert")
        
        XCTAssertTrue(viewModel.meals.isEmpty)
        XCTAssertEqual(viewModel.errorMessage, NetworkError.requestFailed.localizedDescription)
    }
}

