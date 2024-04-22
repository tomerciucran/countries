//
//  CountriesTests.swift
//  CountriesTests
//
//  Created by Tomer Ciucran on 20.03.24.
//

import XCTest
@testable import Countries

final class SearchCountriesViewModelTests: XCTestCase {
    private var sut: SearchCountriesViewModel!
    private var service: MockCountriesService!

    override func setUpWithError() throws {
        try super.setUpWithError()
        
        service = MockCountriesService()
        sut = SearchCountriesViewModel(service: service)
    }

    override func tearDownWithError() throws {
        service = nil
        sut = nil
        
        try super.tearDownWithError()
    }

    func test_searchQueryUpdatesSearchResults() async throws {
        let expectedCountries = [Country(name: Name(common: "name_common", official: "name_official"))]
        service.countries = expectedCountries
        sut.searchQuery = "test"
        
        let expectation = XCTestExpectation(description: "Search results are updated")
        
        let cancellable = sut.$searchResults
            .sink { results in
                if results == expectedCountries {
                    expectation.fulfill()
                }
            }
        
        await fulfillment(of: [expectation], timeout: 0.6)
        
        let result = sut.searchResults.first
        XCTAssertEqual("name_common", result?.name.common)
        XCTAssertEqual("name_official", result?.name.official)
        XCTAssertEqual(sut.state, SearchCountriesViewModel.State.searchResultsLoaded)
        
        cancellable.cancel()
    }
    
    func test_searchQueryUpdatesState_whenError() async throws {
        service.error = CountriesService.CountriesServiceError.invalidURL
        sut.searchQuery = "test"
        
        try await Task.sleep(nanoseconds: 600_000_000)
        
        let expectedState = SearchCountriesViewModel.State.error(CountriesService.CountriesServiceError.invalidURL)
        XCTAssertEqual(expectedState, sut.state)
    }
}
