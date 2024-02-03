//
//  MovieDetailsEntity.swift
//  imdb
//
//  Created by rauan on 12/21/23.
//

import Foundation

struct MovieDetailsEntity: Decodable {
    enum CodingKeys: String, CodingKey {
        case genres
        case originalTitle = "original_title"
        case releaseDate = "release_date"
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
        case posterPath = "poster_path"
        case overview = "overview"
    }
    
    let originalTitle: String?
    let releaseDate: String?
    let voteAverage: Double?
    let voteCount: Int?
    let posterPath: String?
    let overview: String?
    let genres: [Genre]
    
    
    
}
