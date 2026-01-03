//
//  MovieDetailViewModel.swift
//  NexFlix
//
//  Created by Himanshu Dev on 02/01/26.
//

import Foundation

@MainActor
final class MovieDetailViewModel {

    // MARK: - Properties
    let movie: Movie
    var titleText: String { movie.title}
    var overviewText: String { movie.overview}
    var posterURL: URL? {
        guard let path = movie.backdropPath else { return nil }
        return URL(string: "https://image.tmdb.org/t/p/w500\(path)")
    }
    
    var userRatingText: String {
        // MARK: - Placeholder if rating exists in Movie model
        "⭐️ N/A"
    }

    var releaseDateText: String {
        // MARK: - Placeholder if releaseDate exists in Movie model
        "Release: \(movie.releaseDate)"
    }

    // MARK: - Init
    init(movie: Movie) {
        self.movie = movie
    }
}

