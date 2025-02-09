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
    private var userProfileManager = UserProfileManager()
    
    // MARK: inputs
    let setForm: Observable<Void> = Observable(value: ())
    
    let nicknameTextFieldInput: Observable<String?> = Observable(value: nil)
    
    let profileImageButtonTapped: Observable<Void> = Observable(value: ())
    
    let saveButtonTapped: Observable<Void> = Observable(value: ())
    
    let resignButtonTapped: Observable<Void> = Observable(value: ())
    
    // MARK: outputs
    let mode: Observable<ProfileEditMode>
    
    let profileImageNumber: Observable<Int?> = Observable(value: nil)
    
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
        self.setForm.lazyBind { _ in
            self._setForm()
        }
        
        self.nicknameValidationResult.lazyBind { state in
            let isValid = state.isEnabled
            self.profileFormIsValid.value = isValid
        }
        
        self.nicknameTextFieldInput.lazyBind { inputText in
            self.validateNickname(inputText)
        }
        
        self.profileImageButtonTapped.lazyBind { _ in
            self.goToImageSelectScene.value = ()
        }
        
        self.saveButtonTapped.lazyBind { _ in
            self.save()
        }
        
        self.resignButtonTapped.lazyBind { _ in
            self.resignScene.value = ()
        }
    }
    
    private func _setForm() {
        let form: ProfileInfoForm
        if let userProfile = self.userProfileManager.getCurrentProfile() {
            form = ProfileInfoForm(
                imageNumber: userProfile.imageNumber,
                nickname: userProfile.nickname
            )
        } else {
            form = ProfileInfoForm()
        }
        
        self.profileImageNumber.value = form.imageNumber
        self.nicknameValidationResult.value = .valid(nickname: form.nickname)
    }
    
    private func validateNickname(_ input: String?) {
        guard let input else {
            self.nicknameValidationResult.value = .invalid(.invalidLength)
            return
        }
        
        let validNicknameLengthRange = (2..<10)
        guard validNicknameLengthRange.contains(input.count) else {
            self.nicknameValidationResult.value = .invalid(.invalidLength)
            return
        }
        
        let invalidCharacterSet = CharacterSet(arrayLiteral: "@", "#", "$", "%")
        guard input.rangeOfCharacter(from: invalidCharacterSet) == nil else {
            self.nicknameValidationResult.value = .invalid(.invalidCharacter)
            return
        }
        
        let numberCharacterSet = CharacterSet.decimalDigits
        guard input.rangeOfCharacter(from: numberCharacterSet) == nil else {
            self.nicknameValidationResult.value = .invalid(.numberContained)
            return
        }
        
        self.nicknameValidationResult.value = .valid(nickname: input)
    }
    
    private func save() {
        guard let imageNumber = self.profileImageNumber.value else {
            return
        }
        
        let nicknameResult = self.nicknameValidationResult.value
        guard case .valid(let nickname) = nicknameResult else {
            return
        }
        
        let newUserProfileForm = ProfileInfoForm(
            imageNumber: imageNumber,
            nickname: nickname
        )
        
        self.userProfileManager.saveProfile(withForm: newUserProfileForm)
        
        self.resignScene.value = ()
    }
}
