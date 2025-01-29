//
//  ProfileInfo.swift
//  CineHive
//
//  Created by Effie on 1/29/25.
//

import Foundation

struct ProfileInfo {
    let imageNumber: Int
    let nickname: String
    let createdAt: Date
    let likedMovieIDs: [String]
    
    init(
        imageNumber: Int,
        nickname: String,
        createdAt: Date,
        likedMovieIDs: [String]
    ) {
        self.imageNumber = imageNumber
        self.nickname = nickname
        self.createdAt = createdAt
        self.likedMovieIDs = likedMovieIDs
    }
}

extension ProfileInfo: Codable { }
