//
//  APIResult.swift
//  imdb
//
//  Created by rauan on 1/26/24.
//

import Foundation

enum APIResult<A> {
    case success(A)
    case failure(NetworkError)
}

enum NetworkError {
    case networkFail
    case incorrectJSON
    case unknown
    case filedWith(reason: String)
}
