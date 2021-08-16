//
//  Trailer.swift
//  MovieSearch
//
//  Created by Ali Dinç on 07/08/2021.
//

import Foundation


struct TopLevelObjectForTrailers: Codable {
    let results: [Trailer]
}

// MARK: - Result
struct Trailer: Codable {
    let key: String?
    let site: String
    let type: String
    let official: Bool
    let id: String

    enum CodingKeys: String, CodingKey {
        case key, site, type, official
        case id
    }
}
