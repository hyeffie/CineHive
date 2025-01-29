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
    
    init(nickname: String) {
        self.imageNumber = (0..<12).randomElement() ?? 0
        self.nickname = nickname
        self.createdAt = Date()
        self.likedMovieIDs = []
    }
}

extension ProfileInfo: Codable { }
