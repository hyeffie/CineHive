//
//  UserProfileManager.swift
//  CineHive
//
//  Created by Effie on 2/9/25.
//

import Foundation

struct UserProfileManager {
    @UserDefault(key: UserDefaultKey.userProfile)
    private var userProfile: ProfileInfo?
    
    func getCurrentProfile() -> ProfileInfoForm? {
        guard let userProfile = self.userProfile else { return nil }
        return ProfileInfoForm(
            imageNumber: userProfile.imageNumber,
            nickname: userProfile.nickname,
            mbti: userProfile.mbti
        )
    }
    
    mutating func saveProfile(withForm form: ProfileInfoForm) {
        let newUserProfile = ProfileInfo(
            imageNumber: form.imageNumber,
            nickname: form.nickname,
            mbti: form.mbti,
            createdAt: self.userProfile?.createdAt ?? .now,
            likedMovieIDs: self.userProfile?.likedMovieIDs ?? [],
            submittedQueries: []
        )
        
        self.userProfile = newUserProfile
        self.notifyUserProfileUpdate()
    }
    
    
    
    private func notifyUserProfileUpdate() {
        NotificationCenter.default.post(name: CHNotification.userProfileUpdated, object: nil)
    }
}
