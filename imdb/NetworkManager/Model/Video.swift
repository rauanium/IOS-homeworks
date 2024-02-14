//
//  Video.swift
//  imdb
//
//  Created by rauan on 12/26/23.
//

import Foundation

struct VideoEntity: Decodable {
    var results: [Video]
}

struct Video: Decodable {
    var key: String?
    var site: String?
}
