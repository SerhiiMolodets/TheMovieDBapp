//
//  TokenModel.swift
//  TheMovieDBapp
//
//  Created by Сергей Молодец on 23.09.2022.
//

import Foundation

// MARK: - Tokens model
struct Token: Codable {
    let success: Bool
    let expiresAt, requestToken: String

    enum CodingKeys: String, CodingKey {
        case success
        case expiresAt = "expires_at"
        case requestToken = "request_token"
    }
}

// MARK: - ValidateToken model
struct ValidateToken: Codable {
    let username, password, requestToken: String

    enum CodingKeys: String, CodingKey {
        case username, password
        case requestToken = "request_token"
    }
}
// MARK: - TokenBody
struct TokenBody: Codable {
    let requestToken: String

    enum CodingKeys: String, CodingKey {
        case requestToken = "request_token"
    }
}
// MARK: - SessionID
struct SessionID: Codable {
    let success: Bool
    let sessionID: String

    enum CodingKeys: String, CodingKey {
        case success
        case sessionID = "session_id"
    }
}

// MARK: - GuestSessionID
struct GuestSessionID: Codable {
    let success: Bool
    let guestSessionID, expiresAt: String

    enum CodingKeys: String, CodingKey {
        case success
        case guestSessionID = "guest_session_id"
        case expiresAt = "expires_at"
    }
}