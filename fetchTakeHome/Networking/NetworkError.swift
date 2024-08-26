//
//  NetworkError.swift
//  Glorify
//
// Created by Rojee Shrestha on 8/24/24.
// Copyright (c) 2024. All rights reserved.
//

import Foundation

enum NetworkError: Error, Equatable {
    case invalidURL
    case requestFailed
    case decodingFailed
    case custom(errorDescription: String)
    
    
    var localizedDescription: String {
        switch self {
        case .invalidURL:
            return "The URL is invalid."
        case .requestFailed:
            return "The network request failed. Please try again."
        case .decodingFailed:
            return "Failed to decode the response. Please try again."
        case .custom(let errorDescription):
            return errorDescription
        }
    }
}
