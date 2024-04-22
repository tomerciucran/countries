//
//  CountriesServiceTests.swift
//  CountriesTests
//
//  Created by Tomer Ciucran on 21.03.24.
//

import XCTest
@testable import Countries

final class CountriesServiceTests: XCTestCase {
    private var sut: CountriesService!
    private var urlSession: MockURLSession!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        urlSession = MockURLSession()
        sut = CountriesService(urlSession: urlSession)
    }
    
    override func tearDownWithError() throws {
        urlSession = nil
        sut = nil
        
        try super.tearDownWithError()
    }
    
    func test_search_returnsCountriesCorrectly() async throws {
        let expectedResponse = try! JSONDecoder().decode([Country].self, from: expectedResponseData)
        urlSession.result = (expectedResponseData, URLResponse())
        
        let countries = try await sut.search(with: "test")
        
        XCTAssertEqual(countries, expectedResponse)
    }
    
    func test_search_returnsDecodingError_whenError() async throws {
        urlSession.result = (Data(), URLResponse())
        
        do {
            let _ = try await sut.search(with: "test")
            XCTFail()
        } catch {
            XCTAssertEqual(error as? CountriesService.CountriesServiceError, .decodingError)
        }
    }
}

private let expectedResponseData = """
[{
    "name": {
        "common": "common_name",
        "official": "official_name"
    }
 }]
""".data(using: .utf8)!
