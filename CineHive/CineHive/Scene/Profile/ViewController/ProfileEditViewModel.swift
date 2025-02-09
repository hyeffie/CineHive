//
//  ProfileEditViewModel.swift
//  CineHive
//
//  Created by Effie on 2/9/25.
//

import Foundation

enum ProfileEditMode {
    case create
    case update
}

final class ProfileEditViewModel {
    // MARK: helpers
    private let userProfileManager = UserProfileManager()
    
    // MARK: inputs
    let nicknameTextFieldInput: Observable<String?> = Observable(value: nil)
    
    let profileImageButtonTapped: Observable<Void> = Observable(value: ())
    
    let saveButtonTapped: Observable<Void> = Observable(value: ())
    
    let resignButtonTapped: Observable<Void> = Observable(value: ())
    
    // MARK: outputs
    let mode: Observable<ProfileEditMode>
    
    let nicknameValidationResultText: Observable<String?> = Observable(value: nil)
    
    let nicknameIsValid: Observable<Bool> = Observable(value: false)
    
    let resignScene: Observable<Void> = Observable(value: ())
    
    let goToImageSelectScene: Observable<Void> = Observable(value: ())
    
    // MARK: privates
    private lazy var profileForm: Observable<ProfileInfoForm> = {
        let form: ProfileInfoForm
        if let userProfile = self.userProfileManager.getCurrentProfile() {
            form = ProfileInfoForm(
                imageNumber: userProfile.imageNumber,
                nickname: userProfile.nickname
            )
            
        } else {
            form = ProfileInfoForm()
        }
        return Observable(value: form)
    }()
    
    private let nicknameValidationResult: Observable<NicknameValidityState> = Observable(value: .empty)
    
    init(mode: ProfileEditMode) {
        self.mode = Observable(value: mode)
        bind()
    }
    
    private func bind() {
        
    }
}
