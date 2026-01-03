//
//  MockMovieService.swift
//  NexFlixTests
//
//  Created by Himanshu Dev on 03/01/26.
//

@testable import NexFlix
import Foundation

final class MockMovieService: MovieServiceProtocol {

    var trendingResult: Result<[Movie], Error> = .success([])
    var searchResult: Result<[Movie], Error> = .success([])

    func fetchTrending(page: Int) async throws -> [Movie] {
        try trendingResult.get()
    }

    func searchMovies(query: String) async throws -> [Movie] {
        try searchResult.get()
    }
}
