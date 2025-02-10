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
    var mbti: UserMBTI
    var createdAt: Date
    var likedMovieIDs: [Int]
    var submittedQueries: Set<SubmittedQuery>
    
    init(
        imageNumber: Int,
        nickname: String,
        mbti: UserMBTI,
        createdAt: Date,
        likedMovieIDs: [Int],
        submittedQueries: Set<SubmittedQuery>
    ) {
        self.imageNumber = imageNumber
        self.nickname = nickname
        self.mbti = mbti
        self.createdAt = createdAt
        self.likedMovieIDs = likedMovieIDs
        self.submittedQueries = submittedQueries
    }
}

extension ProfileInfo: Codable { }
