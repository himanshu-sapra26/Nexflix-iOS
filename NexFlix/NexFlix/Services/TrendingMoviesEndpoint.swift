//
//  TrendingMoviesEndpoint.swift
//  NexFlix
//
//  Created by Himanshu Dev on 02/01/26.
//

import Foundation
struct TrendingMoviesEndpoint: Endpoint {
    let page: Int
    var path: String { "/trending/movie/day" }
    var queryItems: [URLQueryItem] {
        [URLQueryItem(name: "page", value: "\(page)")]
    }
}
