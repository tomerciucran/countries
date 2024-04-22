//
//  Country.swift
//  Countries
//
//  Created by Tomer Ciucran on 20.03.24.
//

import Foundation

struct Country: Decodable, Hashable, Equatable {
    let name: Name
}

struct Name: Decodable, Hashable, Equatable {
    let common: String
    let official: String
}
