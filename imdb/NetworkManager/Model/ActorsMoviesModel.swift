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
//    let adult: Bool
//    let backdropPath: String?
//    let genreIDS: [Int]
//    let id: Int
//    let originalLanguage: OriginalLanguage
    let originalTitle: String
//    let overview: String
//    let popularity: Double
    let posterPath: String?
    let releaseDate: String?
//    let title: String
//    let video: Bool
//    let voteAverage: Double
//    let voteCount: Int
//    let character: String?
//    let creditID: String
//    let order: Int?
//    let department: DepartmentProduction?
//    let job: Job?

    enum CodingKeys: String, CodingKey {
//        case adult
//        case backdropPath = "backdrop_path"
//        case genreIDS = "genre_ids"
//        case id
//        case originalLanguage = "original_language"
        case originalTitle = "original_title"
//        case overview, popularity
        case posterPath = "poster_path"
        case releaseDate = "release_date"
//        case title, video
//        case voteAverage = "vote_average"
//        case voteCount = "vote_count"
//        case character
//        case creditID = "credit_id"
//        case order, department, job
    }
}

//enum DepartmentProduction: String, Codable {
//    case production = "Production"
//    case writing = "Writing"
//}
//
//enum Job: String, Codable {
//    case executiveProducer = "Executive Producer"
//    case producer = "Producer"
//    case screenplay = "Screenplay"
//    case writer = "Writer"
//}
//
//enum OriginalLanguage: String, Codable {
//    case en = "en"
//    case es = "es"
//    case fr = "fr"
//    case hu = "hu"
//    case it = "it"
//    case ja = "ja"
//    case pt = "pt"
//    case de = "de"
//}
