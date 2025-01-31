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
    
    init(query: String, page: Int, language: String = "ko-KR") {
        self.query = query
        self.page = page
        self.language = language
    }
}
