//
//  ActorImagesModel.swift
//  imdb
//
//  Created by rauan on 1/2/24.
//
import Foundation

// MARK: - ActorImagesModel
struct ActorImagesModel: Decodable {
    let profiles: [Profile]
}

// MARK: - Profile
struct Profile: Decodable {
    let filePath: String

    enum CodingKeys: String, CodingKey {
        case filePath = "file_path"
    }
}

