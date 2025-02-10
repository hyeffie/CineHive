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
    
    let setImageNumber: Observable<Int?> = Observable(value: nil)
    
    let mbtiDidSelect: Observable<MBTI> = Observable(value: MBTI())
    
    let tapGestureDidRecognize: Observable<Void> = Observable(value: ())
    
    let keyboardReturnKeyTapped: Observable<Void> = Observable(value: ())
    
    // MARK: outputs
    let mode: Observable<ProfileEditMode>
    
    let profileImageNumber: Observable<Int?> = Observable(value: nil)
    
    let nicknameFieldText: Observable<String> = Observable(value: "")
    
    let nicknameValidationResultText: Observable<String?> = Observable(value: nil)
    
    let nicknameIsValid: Observable<Bool> = Observable(value: false)
    
    let resignScene: Observable<Void> = Observable(value: ())
    
    let goToImageSelectScene: Observable<Void> = Observable(value: ())
    
    let profileFormIsValid: Observable<Bool> = Observable(value: false)
    
    let setMBTI: Observable<MBTI> = Observable(value: MBTI())
    
    let resignKeyboard: Observable<Void> = Observable(value: ())
    
    // MARK: privates
    private let nicknameValidationResult: Observable<NicknameValidityState> = Observable(value: .empty)
    
    private let mbtiValidationResult: Observable<MBTIValidationState> = Observable(value: .invalid)
    
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
            if case .valid(let nickname) = state {
                self.nicknameFieldText.value = nickname
            }
            self.nicknameValidationResultText.value = state.message
            self.nicknameIsValid.value = state.isEnabled
            self.profileFormIsValid.value = isValid && self.mbtiValidationResult.value.isValid
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
        
        self.setImageNumber.lazyBind { imageNumber in
            guard let imageNumber else { return }
            self.profileImageNumber.value = imageNumber
        }
        
        self.mbtiDidSelect.lazyBind { mbti in
            self.validateMBTI(mbti)
        }
        
        self.mbtiValidationResult.lazyBind { state in
            self.profileFormIsValid.value = state.isValid && self.nicknameValidationResult.value.isEnabled
        }
        
        self.tapGestureDidRecognize.lazyBind { _ in
            self.resignKeyboard.value = ()
        }
        
        self.keyboardReturnKeyTapped.lazyBind { _ in
            self.resignKeyboard.value = ()
        }
    }
    
    private func _setForm() {
        if let userProfile = self.userProfileManager.getCurrentProfile() {
            self.profileImageNumber.value = userProfile.imageNumber
            self.nicknameValidationResult.value = .valid(nickname: userProfile.nickname)
            let mbti = userProfile.mbti
            self.setMBTI.value = MBTI(ei: mbti.ei, ns: mbti.ns, tf: mbti.tf, pj: mbti.pj)
        } else {
            self.profileImageNumber.value = randomizeImageNumber()
            self.nicknameValidationResult.value = .empty
            self.setMBTI.value = MBTI()
        }
    }
    
    private func randomizeImageNumber() -> Int {
        return (0..<12).randomElement() ?? 0
    }
    
    private func validateNickname(_ input: String?) {
        guard let input else {
            self.nicknameValidationResult.value = .empty
            return
        }
        
        guard input.isEmpty == false else {
            self.nicknameValidationResult.value = .empty
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
    
    private func validateMBTI(_ mbti: MBTI) {
        guard let userMBTI = mbti.toUserMBTI() else {
            self.mbtiValidationResult.value = .invalid
            return
        }
        self.mbtiValidationResult.value = .valid(userMBTI)
    }
    
    private func save() {
        guard
            let imageNumber = self.profileImageNumber.value,
            case .valid(let nickname) = self.nicknameValidationResult.value,
            case .valid(let userMBTI) = self.mbtiValidationResult.value
        else {
            return
        }
        
        let newUserProfileForm = ProfileInfoForm(
            imageNumber: imageNumber,
            nickname: nickname,
            mbti: userMBTI
        )
        
        self.userProfileManager.saveProfile(withForm: newUserProfileForm)
        
        self.resignScene.value = ()
    }
}
