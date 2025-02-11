//
//  TrendingMovieResponse.swift
//  CineHive
//
//  Created by Effie on 1/30/25.
//

import Foundation

struct TrendingMovieResponse: Decodable {
    let movies: [TMDBMovieSummary]

    enum CodingKeys: String, CodingKey {
        case movies = "results"
    }
}
