//
//  TrendingMovieRequestParameter.swift
//  CineHive
//
//  Created by Effie on 1/30/25.
//

import Foundation

struct TrendingMovieRequestParameter: Encodable {
    let page: Int = 1
    let language: String = "ko-KR"
}

enum TimeWindow: String {
    case day
    case week
}
