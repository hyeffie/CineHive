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

final class ProfileEditViewModel: BaseViewModelProtocol {
    // MARK: helpers
    private var userProfileManager = UserProfileManager()
    
    struct Input {
        let setForm: Observable<Void> = Observable(value: ())
        
        let nicknameTextFieldInput: Observable<String?> = Observable(value: nil)
        
        let profileImageButtonTapped: Observable<Void> = Observable(value: ())
        
        let saveButtonTapped: Observable<Void> = Observable(value: ())
        
        let resignButtonTapped: Observable<Void> = Observable(value: ())
        
        let setImageNumber: Observable<Int?> = Observable(value: nil)
        
        let mbtiDidSelect: Observable<MBTI> = Observable(value: MBTI())
        
        let tapGestureDidRecognize: Observable<Void> = Observable(value: ())
        
        let keyboardReturnKeyTapped: Observable<Void> = Observable(value: ())
    }

    struct Output {
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
    }
    
    // MARK: privates
    private let nicknameValidationResult: Observable<NicknameValidityState> = Observable(value: .empty)
    
    private let mbtiValidationResult: Observable<MBTIValidationState> = Observable(value: .invalid)
    
    var input: Input
    
    var output: Output
    
    init(mode: ProfileEditMode) {
        self.input = Input()
        self.output = Output(mode: Observable(value: mode))
        transform()
    }
    
    func transform() {
        self.input.setForm.lazyBind { _ in
            self._setForm()
        }
        
        self.input.nicknameTextFieldInput.lazyBind { inputText in
            self.validateNickname(inputText)
        }
        
        self.input.profileImageButtonTapped.lazyBind { _ in
            self.output.goToImageSelectScene.value = ()
        }
        
        self.input.saveButtonTapped.lazyBind { _ in
            self.save()
        }
        
        self.input.resignButtonTapped.lazyBind { _ in
            self.output.resignScene.value = ()
        }
        
        self.input.setImageNumber.lazyBind { imageNumber in
            guard let imageNumber else { return }
            self.output.profileImageNumber.value = imageNumber
        }
        
        self.input.mbtiDidSelect.lazyBind { mbti in
            self.validateMBTI(mbti)
        }
        
        self.input.tapGestureDidRecognize.lazyBind { _ in
            self.output.resignKeyboard.value = ()
        }
        
        self.input.keyboardReturnKeyTapped.lazyBind { _ in
            self.output.resignKeyboard.value = ()
        }
        
        self.nicknameValidationResult.lazyBind { state in
            let isValid = state.isEnabled
            if case .valid(let nickname) = state {
                self.output.nicknameFieldText.value = nickname
            }
            self.output.nicknameValidationResultText.value = state.message
            self.output.nicknameIsValid.value = state.isEnabled
            self.output.profileFormIsValid.value = isValid && self.mbtiValidationResult.value.isValid
        }
        
        self.mbtiValidationResult.lazyBind { state in
            self.output.profileFormIsValid.value = state.isValid && self.nicknameValidationResult.value.isEnabled
        }
    }
    
    private func _setForm() {
        if let userProfile = self.userProfileManager.getCurrentProfile() {
            self.output.profileImageNumber.value = userProfile.imageNumber
            self.nicknameValidationResult.value = .valid(nickname: userProfile.nickname)
            let mbti = userProfile.mbti
            self.output.setMBTI.value = MBTI(ei: mbti.ei, ns: mbti.ns, tf: mbti.tf, pj: mbti.pj)
        } else {
            self.output.profileImageNumber.value = randomizeImageNumber()
            self.nicknameValidationResult.value = .empty
            self.output.setMBTI.value = MBTI()
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
            let imageNumber = self.output.profileImageNumber.value,
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
        
        self.output.resignScene.value = ()
    }
}
