//
//  TrendingMovieRequestParameter.swift
//  CineHive
//
//  Created by Effie on 1/30/25.
//

import Foundation

struct TrendingMovieRequestParameter: Encodable {
    let page: Int
    let language: String
}

enum TimeWindow: String {
    case day
    case week
}
