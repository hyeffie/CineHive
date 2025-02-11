//
//  MovieSummary.swift
//  CineHive
//
//  Created by Effie on 1/31/25.
//

import Foundation

struct TMDBMovieSummary: Decodable {
    let id: Int
    let title: String
    let releaseDate: String?
    let voteAverage: Double?
    let genreIDS: [Int]?
    let overview: String?
    let posterPath: String?

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case releaseDate = "release_date"
        case voteAverage = "vote_average"
        case genreIDS = "genre_ids"
        case overview
        case posterPath = "poster_path"
    }
}
