//
//  ExternalIDModel.swift
//  imdb
//
//  Created by rauan on 1/2/24.
//
import Foundation

// MARK: - ExternalID
struct ExternalIDModel: Codable {
    let id: Int
    let imdbID, wikidataID, facebookID, instagramID: String
    let twitterID: String

    enum CodingKeys: String, CodingKey {
        case id
        case imdbID = "imdb_id"
        case wikidataID = "wikidata_id"
        case facebookID = "facebook_id"
        case instagramID = "instagram_id"
        case twitterID = "twitter_id"
    }
}
