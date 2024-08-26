//
//  MealImageView.swift
//  Glorify
//
// Created by Rojee Shrestha on 8/25/24.
// Copyright (c) 2024. All rights reserved.
//

import SwiftUI

public struct MealImageView: View {
    private let pictureUrl: String
    
    public init(pictureUrl: String) {
        self.pictureUrl = pictureUrl
    }
    
    public var body: some View {
        AsyncImage(url: URL(string: pictureUrl)) { phase in
            switch phase {
            case .success(let image):
                image
                    .resizable()
                    .scaledToFill()
                    .frame(width: 50, height: 50)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
            default:
                Text("No image")
                    .font(.footnote)
                    .lineLimit(nil)
                    .fixedSize(horizontal: false, vertical: true)
                    .foregroundColor(.gray)
                    .frame(width: 50, height: 50)
                    .background(.gray.opacity(0.2))
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .overlay {
                        ProgressView()
                    }
            }
        }
    }
}

