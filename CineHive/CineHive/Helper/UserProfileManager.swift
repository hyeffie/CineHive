//
//  UserProfileManager.swift
//  CineHive
//
//  Created by Effie on 2/9/25.
//

import Foundation

final class UserProfileManager {
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
    
    func getProfileInfo() -> ProfileInfo? {
        return self.userProfile
    }
    
    func saveProfile(withForm form: ProfileInfoForm) {
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
    
    func toggleLike(movieID: Int) {
        guard let userProfile = self.userProfile else { return }
        if userProfile.likedMovieIDs.contains(movieID) {
            self.userProfile?.likedMovieIDs.removeAll { id in id == movieID }
        } else {
            self.userProfile?.likedMovieIDs.append(movieID)
        }
        notifyLikedMovieMutated()
    }
    
    private func notifyLikedMovieMutated() {
        NotificationCenter.default.post(name: CHNotification.userLikedMovieMutated, object: nil)
    }
    
    func deleteSubmittedQuery(_ query: String) {
        let target = SubmittedQuery(submittedDate: .now, query: query)
        self.userProfile?.submittedQueries.remove(target)
        notifySubmittedQueriesMutated()
    }
    
    func deleteAllSubmittedQueries() {
        self.userProfile?.submittedQueries.removeAll()
        notifySubmittedQueriesMutated()
    }
    
    private func notifySubmittedQueriesMutated() {
        NotificationCenter.default.post(name: CHNotification.userSubmittedQueryMutated, object: nil)
    }
    
    func findMovieIfLiked(movieID: Int) -> Bool? {
        return self.userProfile?.likedMovieIDs.contains(movieID)
    }
}
