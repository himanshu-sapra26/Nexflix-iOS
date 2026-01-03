//
//  Movie+TestFactory.swift
//  NexFlixTests
//
//  Created by Himanshu Dev on 03/01/26.
//

import Foundation
@testable import NexFlix
import Foundation

extension Movie {
    /// Factory method to create test Movie objects easily
    static func mock(
        id: Int = 1,
        title: String = "Test Movie",
        overview: String = "Overview",
        posterPath: String? = nil,
        backdropPath: String? = nil,
        voteAverage: Double = 8.0,
        releaseDate: String = "2024-01-01"
    ) -> Movie {
        Movie(
            id: id,
            title: title,
            overview: overview,
            posterPath: posterPath,
            backdropPath: backdropPath,
            voteAverage: voteAverage,
            releaseDate: releaseDate
        )
    }
}
