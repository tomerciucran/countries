//
//  CountriesService.swift
//  Countries
//
//  Created by Tomer Ciucran on 20.03.24.
//

import Foundation

protocol CountriesServiceProtocol {
    func search(with text: String) async throws -> [Country]
}

final class CountriesService: CountriesServiceProtocol {
    enum CountriesServiceError: Error {
        case invalidURL
        case decodingError
    }
    
    private let urlSession: URLSessionProtocol
    
    init(urlSession: URLSessionProtocol = URLSession.shared) {
        self.urlSession = urlSession
    }
    
    func search(with text: String) async throws -> [Country] {
        guard let url = URL(string: "https://restcountries.com/v3.1/name/\(text)") else {
            throw CountriesServiceError.invalidURL
        }
        
        let (data, _) = try await urlSession.data(from: url)
        
        do {
            let countries = try JSONDecoder().decode([Country].self, from: data)
            return countries
        } catch {
            throw CountriesServiceError.decodingError
        }
    }
}
