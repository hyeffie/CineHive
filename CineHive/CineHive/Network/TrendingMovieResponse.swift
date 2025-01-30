//
//  TrendingMovieResponse.swift
//  CineHive
//
//  Created by Effie on 1/30/25.
//

import Foundation

struct TrendingMovieResponse: Decodable {
    let movies: [MovieSummary]

    enum CodingKeys: String, CodingKey {
        case movies = "results"
    }
    
    struct MovieSummary: Decodable {
        let id: Int
        let title: String
        let overview: String
    }
}
