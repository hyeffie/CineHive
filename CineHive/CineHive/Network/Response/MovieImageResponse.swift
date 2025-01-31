//
//  MovieImageResponse.swift
//  CineHive
//
//  Created by Effie on 2/1/25.
//

import Foundation

struct MovieImageResponse: Decodable {
    let id: Int
    let backdrops: [ImageDetail]
    let posters: [ImageDetail]
    
    struct ImageDetail: Decodable {
        let filePath: String?

        enum CodingKeys: String, CodingKey {
            case filePath = "file_path"
        }
    }
}
