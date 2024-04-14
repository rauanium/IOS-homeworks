//
//  MovieCastModel.swift
//  imdb
//
//  Created by rauan on 1/2/24.
//

import Foundation

// MARK: - MovieCast
struct MovieCastModel: Decodable {
    let id: Int
    let cast: [Cast]
}

// MARK: - Cast
struct Cast: Decodable {
    let adult: Bool
    let gender, id: Int
    let name, originalName: String
    let popularity: Double
    let profilePath: String?
    let castID: Int?
    let character: String?
    let creditID: String
    let order: Int?
    let job: String?

    enum CodingKeys: String, CodingKey {
        case adult, gender, id
        case name
        case originalName = "original_name"
        case popularity
        case profilePath = "profile_path"
        case castID = "cast_id"
        case character
        case creditID = "credit_id"
        case order, job
    }
}

enum Department: String, Decodable {
    case acting = "Acting"
}
