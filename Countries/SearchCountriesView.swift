//
//  SearchCountriesView.swift
//  Countries
//
//  Created by Tomer Ciucran on 20.03.24.
//

import SwiftUI

struct SearchCountriesView: View {
    @ObservedObject var viewModel: SearchCountriesViewModel
    
    
    var body: some View {
        NavigationView {
            VStack {
                TextField("Search...", text: $viewModel.searchQuery)
                    .textFieldStyle(.roundedBorder)
                    .padding()
                List(viewModel.searchResults, id: \.self) { result in
                    Text(result.name.common)
                }
            }
        }
        .navigationTitle("Search")
    }
}

#Preview {
    SearchCountriesView(viewModel: SearchCountriesViewModel(service: CountriesService()))
}
