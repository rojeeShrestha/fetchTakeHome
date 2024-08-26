//
//  MockURLSession.swift
//  Glorify
//
// Created by Rojee Shrestha on 8/25/24.
// Copyright (c) 2024. All rights reserved.
//

import Foundation

protocol URLSessionProtocol {
    func data(from url: URL) async throws -> (Data, URLResponse)
}

class MockURLSession: URLSessionProtocol {
    var nextData: Data?
    var nextError: Error?
    
    func data(from url: URL) async throws -> (Data, URLResponse) {
        if let error = nextError {
            throw error
        }
        let response = URLResponse(url: url, mimeType: nil, expectedContentLength: 0, textEncodingName: nil)
        return (nextData ?? Data(), response)
    }
}

extension URLSession: URLSessionProtocol {}
