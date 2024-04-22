//
//  URLSessionProtocol.swift
//  Countries
//
//  Created by Tomer Ciucran on 20.03.24.
//

import Foundation

protocol URLSessionProtocol {
    func data(from url: URL) async throws -> (Data, URLResponse)
}

extension URLSession: URLSessionProtocol {
    func data(from url: URL) async throws -> (Data, URLResponse) {
        return try await data(from: url, delegate: nil)
    }
}


