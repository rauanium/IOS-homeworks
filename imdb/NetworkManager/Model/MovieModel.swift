//
//  MovieModel.swift
//  imdb
//
//  Created by rauan on 1/2/24.
//
import Foundation

// MARK: - Movie
struct MovieModel: Codable {
    let results: [Result]

    enum CodingKeys: String, CodingKey {
        case  results
    }
}

// MARK: - Result
struct Result: Codable, Hashable {
    let backdropPath: String?
    let genreIDS: [Int]
    let id: Int
    let originalLanguage, originalTitle: String
    let posterPath, title: String

    enum CodingKeys: String, CodingKey {
        case backdropPath = "backdrop_path"
        case genreIDS = "genre_ids"
        case id
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case posterPath = "poster_path"
        case title
    }
}

