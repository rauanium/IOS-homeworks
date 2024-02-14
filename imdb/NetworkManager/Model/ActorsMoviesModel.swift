//
//  ActorsMoviesModel.swift
//  imdb
//
//  Created by rauan on 1/2/24.
//
import Foundation

// MARK: - ActorsMoviesModel
struct ActorsMoviesModel: Codable {
    let cast, crew: [ActorsMoviesInfo]
    let id: Int
}

// MARK: - Cast
struct ActorsMoviesInfo: Codable {
    let originalTitle: String
    let posterPath: String?
    let releaseDate: String?

    enum CodingKeys: String, CodingKey {
        case originalTitle = "original_title"
        case posterPath = "poster_path"
        case releaseDate = "release_date"
    }
}
