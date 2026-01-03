//
//  NetworkError.swift
//  NexFlix
//
//  Created by Himanshu Dev on 02/01/26.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case noInternet
    case timeout
    case cancelled
    case invalidResponse
    case unauthorized
    case notFound
    case serverError(Int)
    case statusCode(Int)  
    case decoding
    case unknown(Error)
}
// MARK: - Extension Network Error
extension NetworkError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid request URL."

        case .noInternet:
            return "No internet connection. Please check your network."

        case .timeout:
            return "The request timed out. Please try again."

        case .cancelled:
            return "The request was cancelled."

        case .unauthorized:
            return "Unauthorized access. Please log in again."

        case .notFound:
            return "Requested resource not found."

        case .serverError:
            return "Server error. Please try again later."

        case .decoding:
            return "Failed to decode server response."

        case .statusCode(let code):
            return "Request failed with status code \(code)."

        case .invalidResponse:
            return "Invalid server response."

        case .unknown:
            return "Something went wrong. Please try again."
        }
    }
}
