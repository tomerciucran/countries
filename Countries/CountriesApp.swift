//
//  CountriesApp.swift
//  Countries
//
//  Created by Tomer Ciucran on 20.03.24.
//

import SwiftUI

@main
struct CountriesApp: App {
    var body: some Scene {
        WindowGroup {
            SearchCountriesView(viewModel: SearchCountriesViewModel(service: CountriesService()))
        }
    }
}
