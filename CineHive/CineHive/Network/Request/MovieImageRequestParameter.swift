//
//  MovieImageRequestParameter.swift
//  CineHive
//
//  Created by Effie on 2/1/25.
//

import Foundation

struct MovieImageRequestParameter: Encodable {
    let imageLanguage: String
    let language: String
    
    enum CodingKeys: String, CodingKey {
        case imageLanguage = "include_image_language"
        case language
    }
    
    init(imageLanguage: String = "null", language: String = "ko-KR") {
        self.imageLanguage = imageLanguage
        self.language = language
    }
}
