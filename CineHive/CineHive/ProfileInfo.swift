//
//  ProfileInfo.swift
//  CineHive
//
//  Created by Effie on 1/29/25.
//

import Foundation

struct ProfileInfo {
    var imageNumber: Int
    var nickname: String
    var createdAt: Date
    var likedMovieIDs: [Int]
    
    init(
        imageNumber: Int,
        nickname: String,
        createdAt: Date,
        likedMovieIDs: [Int]
    ) {
        self.imageNumber = imageNumber
        self.nickname = nickname
        self.createdAt = createdAt
        self.likedMovieIDs = likedMovieIDs
    }
}

extension ProfileInfo: Codable { }
