//
//  MovieResponse.swift
//  NexFlix
//
//  Created by Himanshu Dev on 02/01/26.
//

import Foundation
struct MovieResponse: Decodable {
    let page: Int
    let results: [Movie]
}
