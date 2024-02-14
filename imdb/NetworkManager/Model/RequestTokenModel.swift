//
//  RequestTokenModel.swift
//  imdb
//
//  Created by rauan on 1/26/24.
//

import Foundation

struct RequestTokenModel: Decodable {
    let success: Bool
    let requestToken: String
    let expiresAt: String

    enum CodingKeys: String, CodingKey {
        case success
        case requestToken = "request_token"
        case expiresAt = "expires_at"
    }
}

struct ValidateAuthenticationModel: Encodable {
    let username: String
    let password: String
    let requestToken: String
    
    enum CodingKeys: String, CodingKey {
        case username
        case password
        case requestToken = "request_token"
    }
    
    func toDictionary() -> [String: Any] {
        return [
            "username": self.username,
            "password": self.password,
            "request_token": self.requestToken,
        ]
    }
    
    
}




