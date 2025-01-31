//
//  SearchMovieRequestParameter.swift
//  CineHive
//
//  Created by Effie on 1/31/25.
//

import Foundation

struct SearchMovieRequestParameter: Encodable {
    let query: String
    let page: Int
    let language: String
}
