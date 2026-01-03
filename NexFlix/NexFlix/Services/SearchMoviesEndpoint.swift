//
//  SearchMoviesEndpoint.swift
//  NexFlix
//
//  Created by Himanshu Dev on 02/01/26.
//

import Foundation
struct SearchMoviesEndpoint: Endpoint {
    let query: String
    var path: String { "/search/movie" }
    var queryItems: [URLQueryItem] { [URLQueryItem(name: "query", value: query)] }
}
