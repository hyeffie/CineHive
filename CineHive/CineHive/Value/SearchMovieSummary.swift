//
//  SearchMovieSummary.swift
//  CineHive
//
//  Created by Effie on 2/1/25.
//

import Foundation

struct SearchMovieSummary {
    let id: Int
    let posterURL: URL?
    let title: String
    let dateString: String
    let genres: [String]
    let liked: Bool
}
