//
//  SearchMovieResponse.swift
//  CineHive
//
//  Created by Effie on 1/31/25.
//

import Foundation

struct SearchMovieResponse: Decodable {
    let page: Int
    let results: [MovieSummary]
    let totalPages, totalResults: Int

    enum CodingKeys: String, CodingKey {
        case page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}
