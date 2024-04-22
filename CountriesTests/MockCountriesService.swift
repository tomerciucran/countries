//
//  MockCountriesService.swift
//  CountriesTests
//
//  Created by Tomer Ciucran on 21.03.24.
//

import Foundation
@testable import Countries

final class MockCountriesService: CountriesServiceProtocol {
    var countries: [Country] = []
    var error: CountriesService.CountriesServiceError?
    
    func search(with text: String) async throws -> [Countries.Country] {
        if let error = error {
            throw error
        }
        
        return countries
    }
}
