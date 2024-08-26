//
//  NetworkManagerTests.swift
//  Glorify
//
// Created by Rojee Shrestha on 8/25/24.
// Copyright (c) 2024. All rights reserved.
//

import XCTest
@testable import fetchTakeHome

final class NetworkManagerTests: XCTestCase {
    var mockSession: MockURLSession!
    var networkManager: NetworkManager!

    override func setUp() {
        super.setUp()
        mockSession = MockURLSession()
        networkManager = NetworkManager(session: mockSession)
    }

    override func tearDown() {
        mockSession = nil
        networkManager = nil
        super.tearDown()
    }

    func testFetchMeals_Success() async {
        // Provide mock meal data for test purpose. We could create mock response too but this will do for this simple task
        let meal = Meal(id: "123", name: "Test Meal", thumbnailURL: "test_thumbnail")
        let mealResponse = MealResponse(meals: [meal])
        let encodedData = try! JSONEncoder().encode(mealResponse)
        mockSession.nextData = encodedData
        
        let result = await networkManager.fetchMeals(category: "Dessert")
        
        switch result {
        case .success(let meals):
            XCTAssertEqual(meals.count, 1)
            XCTAssertEqual(meals.first?.name, "Test Meal")
        case .failure:
            XCTFail("Expected success but got failure")
        }
    }

    func testFetchMeals_RequestFailed() async {
        mockSession.nextError = URLError(.notConnectedToInternet)
        
        let result = await networkManager.fetchMeals(category: "Dessert")
        
        switch result {
        case .success:
            XCTFail("Expected failure but got success")
        case .failure(let error):
            XCTAssertEqual(error, .requestFailed)
        }
    }
}
