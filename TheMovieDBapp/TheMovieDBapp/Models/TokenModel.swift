//
//  TokenModel.swift
//  TheMovieDBapp
//
//  Created by Сергей Молодец on 23.09.2022.
//

import Foundation

// MARK: - Token
struct Token: Codable {
    let success: Bool
    let expiresAt, requestToken: String

    enum CodingKeys: String, CodingKey {
        case success
        case expiresAt = "expires_at"
        case requestToken = "request_token"
    }
}

// MARK: - ValidateToken
struct ValidateToken: Codable {
    let username, password, requestToken: String

    enum CodingKeys: String, CodingKey {
        case username, password
        case requestToken = "request_token"
    }
}
