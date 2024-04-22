//
//  SearchCountriesViewModel.swift
//  Countries
//
//  Created by Tomer Ciucran on 20.03.24.
//

import Foundation
import Combine

final class SearchCountriesViewModel: ObservableObject {
    enum State: Equatable {
        static func == (lhs: SearchCountriesViewModel.State, rhs: SearchCountriesViewModel.State) -> Bool {
            switch (lhs, rhs) {
            case (.initial, .initial):
                return true
            case (.searchResultsLoaded, .searchResultsLoaded):
                return true
            case (let .error(lhsError), let .error(rhsError)):
                return lhsError.localizedDescription == rhsError.localizedDescription
            default:
                return false
            }
        }
        
        case initial
        case error(Error)
        case searchResultsLoaded
    }
    
    @Published var searchQuery: String
    @Published var searchResults: [Country]
    
    private var cancellables: Set<AnyCancellable> = []
    private(set) var state: State = .initial
    
    private let service: CountriesServiceProtocol
    
    init(searchQuery: String = "", 
         searchResults: [Country] = [],
         service: CountriesServiceProtocol) {
        self.searchQuery = searchQuery
        self.searchResults = searchResults
        self.service = service
        
        $searchQuery
            .removeDuplicates()
            .debounce(for: 0.5, scheduler: RunLoop.main)
            .sink { [weak self] in
            self?.search(with: $0)
        }
        .store(in: &cancellables)
    }
    
    private func search(with text: String) {
        Task {
            do {
                let countries = try await service.search(with: text)
                
                await MainActor.run {
                    searchResults = countries
                    state = .searchResultsLoaded
                }
            } catch {
                state = .error(error)
            }
        }
    }
}
