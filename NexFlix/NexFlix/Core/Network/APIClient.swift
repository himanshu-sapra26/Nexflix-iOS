//
//  APIClient.swift
//  NexFlix
//
//  Created by Himanshu Dev on 02/01/26.
//

import Foundation
final class APIClient {
    
    private let session: URLSession
    private let apiKey = "56e768ce272220bda24e75d7619659c5"
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func request<T: Decodable>(_ endpoint: Endpoint) async throws -> T {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.themoviedb.org"
        components.path = "/3" + endpoint.path
        components.queryItems = endpoint.queryItems + [
            URLQueryItem(name: "api_key", value: apiKey)
        ]
        
        guard let url = components.url else {
            throw NetworkError.invalidURL
        }
        
        do {
            let (data, response) = try await session.data(from: url)
            
            guard let http = response as? HTTPURLResponse else {
                throw NetworkError.invalidResponse
            }
            
            switch http.statusCode {
            case 200..<300:
                do {
                    return try JSONDecoder().decode(T.self, from: data)
                } catch {
                    throw NetworkError.decoding
                }
                
            case 401:
                throw NetworkError.unauthorized
                
            case 404:
                throw NetworkError.notFound
                
            case 500..<600:
                throw NetworkError.serverError(http.statusCode)
                
            default:
                throw NetworkError.statusCode(http.statusCode)
            }
            
        } catch let error as URLError {
            switch error.code {
            case .notConnectedToInternet, .networkConnectionLost:
                throw NetworkError.noInternet
                
            case .timedOut:
                throw NetworkError.timeout
                
            case .cancelled:
                throw NetworkError.cancelled
                
            default:
                throw NetworkError.unknown(error)
            }
        } catch {
            throw NetworkError.unknown(error)
        }
    }
}
