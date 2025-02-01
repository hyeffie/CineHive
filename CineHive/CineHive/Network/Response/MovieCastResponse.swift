//
//  MovieCastResponse.swift
//  CineHive
//
//  Created by Effie on 2/1/25.
//

import Foundation

struct MovieCastResponse: Decodable {
    let id: Int
    let cast: [Cast]
    
    struct Cast: Decodable {
        let id: Int
        let profilePath: String?
        let name: String?
        let character: String?
        
        enum CodingKeys: String, CodingKey {
            case profilePath = "profile_path"
            case id, name, character
        }
    }
}
