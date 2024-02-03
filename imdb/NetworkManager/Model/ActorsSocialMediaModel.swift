//
//  ActorsSocialMediaModel.swift
//  imdb
//
//  Created by rauan on 1/2/24.
//

import Foundation

// MARK: - ActorsMoviesModel
struct ActorsSocialMediaModel: Codable {
    let id: Int
    let freebaseMid, freebaseID, imdbID: String
    let tvrageID: Int
    let wikidataID: String
    let facebookID: String?
    let instagramID: String
    let tiktokID: String?
    let twitterID: String
    let youtubeID: String?

    enum CodingKeys: String, CodingKey {
        case id
        case freebaseMid = "freebase_mid"
        case freebaseID = "freebase_id"
        case imdbID = "imdb_id"
        case tvrageID = "tvrage_id"
        case wikidataID = "wikidata_id"
        case facebookID = "facebook_id"
        case instagramID = "instagram_id"
        case tiktokID = "tiktok_id"
        case twitterID = "twitter_id"
        case youtubeID = "youtube_id"
    }
}

