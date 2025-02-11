//
//  ProfileInfoViewModel.swift
//  CineHive
//
//  Created by Effie on 2/11/25.
//

import Foundation

final class ProfileInfoViewModel: BaseViewModelProtocol {
    struct Input {
        let initialized: Observable<Void> = Observable(value: ())
    }
    
    struct Output {
        let profileImageName: Observable<String?> = Observable(value: nil)
        
        let nicknameLabelText: Observable<String?> = Observable(value: nil)
        
        let createdAtLabelText: Observable<String?> = Observable(value: nil)
        
        let movieBoxLabelText: Observable<String?> = Observable(value: nil)
    }
    
    var input: Input
    
    var output: Output
    
    private let profileManager: UserProfileManager
    
    private let dateEncoder = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yy.MM.dd"
        return dateFormatter
    }()
    
    init(profileManager: UserProfileManager) {
        self.input = Input()
        self.output = Output()
        self.profileManager = profileManager
        addNotificationObserver()
        transform()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func transform() {
        self.input.initialized.bind { _ in
            self.configureInfo()
        }
    }
    
    private func addNotificationObserver() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.configureInfo),
            name: CHNotification.userProfileUpdated,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.configureInfo),
            name: CHNotification.userLikedMovieMutated,
            object: nil
        )
    }
    
    @objc private func configureInfo() {
        guard let profileInfo = self.profileManager.getProfileInfo() else { return }
        
        let imageNumber = profileInfo.imageNumber
        let imageName = CHImageName.profileImage(number: imageNumber)
        self.output.profileImageName.value = imageName
        
        self.output.nicknameLabelText.value = profileInfo.nickname
        
        let createdAt = self.dateEncoder.string(from: profileInfo.createdAt)
        self.output.createdAtLabelText.value = "\(createdAt) 가입"
        
        let likedMovieCount = profileInfo.likedMovieIDs.count
        self.output.movieBoxLabelText.value = "\(likedMovieCount) 개의 무비박스 보관중"
    }
}
