//
//  Movie.swift
//  MovieSearch
//
//  Created by Ali Dinç on 06/08/2021.
//

import Foundation


struct TopLevelObject: Codable {
    let results: [Movie]
}

// MARK: - Result
struct Movie: Codable {
    let originalLanguage, originalTitle, overview: String
    let popularity: Double
    let id: Int?
    let posterPath: String?
    let backdropPath: String?
    let releaseDate: String?
    let title: String
    let voteAverage: Double

    enum CodingKeys: String, CodingKey {
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case overview, popularity
        case posterPath = "poster_path"
        case backdropPath = "backdrop_path"
        case releaseDate = "release_date"
        case title, id
        case voteAverage = "vote_average"
    }
}
