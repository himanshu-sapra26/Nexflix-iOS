//
//  MovieServiceProtocol.swift
//  NexFlix
//
//  Created by Himanshu Dev on 02/01/26.
//

import Foundation
protocol MovieServiceProtocol {
    func fetchTrending(page: Int) async throws -> [Movie]
    func searchMovies(query: String) async throws -> [Movie]
}
