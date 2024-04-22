//
//  File.swift
//  CountriesTests
//
//  Created by Tomer Ciucran on 21.03.24.
//

import Foundation
@testable import Countries

final class MockURLSession: URLSessionProtocol {
    var result: (Data, URLResponse)?
    
    func data(from url: URL) async throws -> (Data, URLResponse) {
        if let result = result {
            return result
        }
        
        return (Data(), URLResponse())
    }
}
