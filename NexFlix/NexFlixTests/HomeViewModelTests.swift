//
//  HomeViewModelTests.swift
//  NexFlixTests
//
//  Created by Himanshu Dev on 03/01/26.
//


import XCTest
@testable import NexFlix

@MainActor
final class HomeViewModelTests: XCTestCase {

    // MARK: - Properties

    private var viewModel: HomeViewModel!
    private var mockService: MockMovieService!

    // MARK: - Setup / Teardown

    override func setUp() {
        super.setUp()
        mockService = MockMovieService()
        viewModel = HomeViewModel(service: mockService)
    }

    override func tearDown() {
        viewModel = nil
        mockService = nil
        super.tearDown()
    }

    // MARK: - Tests

    func test_loadInitialMovies_success() async {
        // Given
        let movies = [
            Movie.mock(id: 1, title: "Movie 1"),
            Movie.mock(id: 2, title: "Movie 2")
        ]

        mockService.trendingResult = .success(movies)

        let expectation = XCTestExpectation(description: "Movies loaded")

        viewModel.onStateChange = { state in
            if case .loaded(let result) = state {
                XCTAssertEqual(result.count, 2)
                XCTAssertEqual(result.first?.title, "Movie 1")
                expectation.fulfill()
            }
        }

        // When
        await viewModel.loadInitialMovies()

        // Then
        await fulfillment(of: [expectation], timeout: 1)
    }

    func test_loadInitialMovies_failure() async {
        // Given
        mockService.trendingResult = .failure(NetworkError.noInternet)

        let expectation = XCTestExpectation(description: "Error state emitted")

        viewModel.onStateChange = { state in
            if case .error(let message) = state {
                XCTAssertEqual(message, "Failed to load movies")
                expectation.fulfill()
            }
        }

        // When
        await viewModel.loadInitialMovies()

        // Then
        await fulfillment(of: [expectation], timeout: 1)
    }

    func test_loadMoreIfNeeded_triggersPagination() async {
        // Given
        let movies = (1...10).map {
            Movie.mock(id: $0, title: "Movie \($0)")
        }

        mockService.trendingResult = .success(movies)

        let expectation = XCTestExpectation(description: "Pagination triggered")

        var loadedCount = 0

        viewModel.onStateChange = { state in
            if case .loaded(let result) = state {
                loadedCount += 1
                if loadedCount == 2 {
                    XCTAssertEqual(result.count, 10)
                    expectation.fulfill()
                }
            }
        }

        // When
        await viewModel.loadInitialMovies()
        await viewModel.loadMoreIfNeeded(currentIndex: 8)

        // Then
        await fulfillment(of: [expectation], timeout: 1)
    }

    func test_searchMovies_success() async {
        // Given
        let searchResults = [
            Movie.mock(id: 99, title: "Batman")
        ]

        mockService.searchResult = .success(searchResults)

        let expectation = XCTestExpectation(description: "Search results loaded")

        viewModel.onStateChange = { state in
            if case .loaded(let movies) = state {
                XCTAssertEqual(movies.count, 1)
                XCTAssertEqual(movies.first?.title, "Batman")
                expectation.fulfill()
            }
        }

        // When
        await viewModel.searchMovies(query: "Batman")

        // Then
        await fulfillment(of: [expectation], timeout: 1)
    }

    func test_searchMovies_failure() async {
        // Given
        mockService.searchResult = .failure(NetworkError.noInternet)

        let expectation = XCTestExpectation(description: "Search error emitted")

        viewModel.onStateChange = { state in
            if case .error(let message) = state {
                XCTAssertEqual(message, "Failed to search movies")
                expectation.fulfill()
            }
        }

        // When
        await viewModel.searchMovies(query: "Batman")

        // Then
        await fulfillment(of: [expectation], timeout: 1)
    }
}
