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
    let setForm: Observable<Void> = Observable(value: ())
    
    let nicknameTextFieldInput: Observable<String?> = Observable(value: nil)
    
    let profileImageButtonTapped: Observable<Void> = Observable(value: ())
    
    let saveButtonTapped: Observable<Void> = Observable(value: ())
    
    let resignButtonTapped: Observable<Void> = Observable(value: ())
    
    // MARK: outputs
    let mode: Observable<ProfileEditMode>
    
    let profileImageName: Observable<String?> = Observable(value: nil)
    
    let nicknameValidationResultText: Observable<String?> = Observable(value: nil)
    
    let nicknameIsValid: Observable<Bool> = Observable(value: false)
    
    let resignScene: Observable<Void> = Observable(value: ())
    
    let goToImageSelectScene: Observable<Void> = Observable(value: ())
    
    let profileFormIsValid: Observable<Bool> = Observable(value: false)
    
    // MARK: privates
    private let nicknameValidationResult: Observable<NicknameValidityState> = Observable(value: .empty)
    
    init(mode: ProfileEditMode) {
        self.mode = Observable(value: mode)
        bind()
    }
    
    private func bind() {
        
    }
}
