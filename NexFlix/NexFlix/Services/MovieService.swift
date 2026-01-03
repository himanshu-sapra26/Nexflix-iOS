//
//  MovieService.swift
//  NexFlix
//
//  Created by Himanshu Dev on 02/01/26.
//

import Foundation
final class MovieService: MovieServiceProtocol {

    private let apiClient: APIClient

    init(apiClient: APIClient = APIClient()) {
        self.apiClient = apiClient
    }

    func fetchTrending(page: Int) async throws -> [Movie] {
        let endpoint = TrendingMoviesEndpoint(page: page)
        let response: MovieResponse = try await apiClient.request(endpoint)
        print(response.results)
        print(response.results.count)
        return response.results
    }

    func searchMovies(query: String) async throws -> [Movie] {
        let endpoint = SearchMoviesEndpoint(query: query)
        let response: MovieResponse = try await apiClient.request(endpoint)
        return response.results
    }
}

