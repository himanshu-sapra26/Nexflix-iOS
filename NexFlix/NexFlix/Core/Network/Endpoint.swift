//
//  Endpoint.swift
//  NexFlix
//
//  Created by Himanshu Dev on 02/01/26.
//

import Foundation
protocol Endpoint {
    var path: String { get }
    var queryItems: [URLQueryItem] { get }
}
