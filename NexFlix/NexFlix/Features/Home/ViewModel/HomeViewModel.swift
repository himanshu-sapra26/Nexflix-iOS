//
//  HomeViewModel.swift
//  NexFlix
//
//  Created by Himanshu Dev on 02/01/26.
//


import Foundation

@MainActor
final class HomeViewModel {

    // MARK: - State

    enum State {
        case idle
        case loading
        case loaded([Movie])
        case error(String)
    }

    // MARK: - Output
    var onStateChange: ((State) -> Void)?

    // MARK: - Dependencies

    private let service: MovieServiceProtocol

    // MARK: - Pagination

    private var currentPage = 1
    private var movies: [Movie] = []
    private var isLoading = false

    // MARK: - Init

    init(service: MovieServiceProtocol) {
        self.service = service
    }


    // MARK: - Loads the first page of movies
    func loadInitialMovies() async {
        currentPage = 1
        movies.removeAll()
        await fetchMovies()
    }

    // MARK: -Loads next page if user scrolls near the end
    func loadMoreIfNeeded(currentIndex: Int) async {
        guard currentIndex >= movies.count - 5 else { return }
        await fetchMovies()
    }

    // MARK: - Private
    private func fetchMovies() async {
        guard !isLoading else { return }
        isLoading = true
        onStateChange?(.loading)
        
        do {
            let newMovies = try await service.fetchTrending(page: currentPage)
            
            // MARK: - Remove duplicates by ID
            let uniqueMovies = newMovies.filter { newMovie in
                !movies.contains(where: { $0.id == newMovie.id })
            }
            
            movies.append(contentsOf: uniqueMovies)
            currentPage += 1
            onStateChange?(.loaded(movies))
            
        } catch {
            onStateChange?(.error("Failed to load movies"))
        }
        
        isLoading = false
    }


    
    
    func searchMovies(query: String) async {
        if query.isEmpty {
            await loadInitialMovies()
            return
        }
        do {
            let results = try await service.searchMovies(query: query)
            movies = results
            onStateChange?(.loaded(movies))
        } catch {
            onStateChange?(.error("Failed to search movies"))
        }
    }
}

