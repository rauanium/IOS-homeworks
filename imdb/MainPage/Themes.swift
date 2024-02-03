//
//  Themes.swift
//  imdb
//
//  Created by rauan on 1/11/24.
//

import Foundation

enum Themes: String, CaseIterable {
    case nowPlaying = "Now Playing"
    case upcoming = "Upcoming"
    case popular = "Popular"    
    case topRated = "Top Rated"

    var key: String {
        return rawValue
    }
    
    var urlPath: String {
        switch self {
        case .nowPlaying:
            return "now_playing"
        case .upcoming:
            return "upcoming"
        case .popular:
            return "popular"        
        case .topRated:
            return "top_rated"
        }
    }
    
}
