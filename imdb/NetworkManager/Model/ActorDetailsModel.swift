//
//  ActorDetailsModel.swift
//  imdb
//
//  Created by rauan on 1/2/24.
//
import Foundation

// MARK: - ActorDetailsModel
struct ActorDetailsModel: Decodable {
    let adult: Bool
    let biography, birthday: String
    let deathday: String?
    let id: Int
    let imdbID, name, placeOfBirth: String
    let profilePath: String?

    enum CodingKeys: String, CodingKey {
        case adult
        case biography, birthday, deathday, id
        case imdbID = "imdb_id"
        case name
        case placeOfBirth = "place_of_birth"
        case profilePath = "profile_path"
    }
}
