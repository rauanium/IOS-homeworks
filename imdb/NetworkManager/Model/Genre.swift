//
//  Genre.swift
//  imdb
//
//  Created by rauan on 12/21/23.
//

import Foundation

struct Genre: Decodable {
    var id: Int
    var name: String
}

struct GenresEntity: Decodable {
    let genres: [Genre]
}
