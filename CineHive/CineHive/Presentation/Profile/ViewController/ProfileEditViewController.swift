//
//  ProfileEditViewController.swift
//  CineHive
//
//  Created by Effie on 1/24/25.
//

import UIKit

final class ProfileEditViewController: BaseViewController {
    private let selectedProfileImageView = SelectedProfileImageView(imageName: nil)
    
    private let nicknameTextField = NicknameTextField()
    
    private let completeButton = ThemePillShapeButton(title: "완료")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "프로필 설정"
        
        configureView()
        
        randomizeProfileImage()
        
        setNickname("")
    }
}

// MARK: - Configuring Views
extension ProfileEditViewController {
    private func configureView() {
        let vOffset = 30
        let hInset = 16
        
        self.view.addSubview(self.selectedProfileImageView)
        self.selectedProfileImageView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide).offset(vOffset)
            make.centerX.equalTo(self.view.safeAreaLayoutGuide)
            make.width.equalTo(self.view.safeAreaLayoutGuide).multipliedBy(0.25)
        }
        
        self.view.addSubview(self.nicknameTextField)
        self.nicknameTextField.snp.makeConstraints { make in
            make.top.equalTo(self.selectedProfileImageView.snp.bottom).offset(vOffset)
            make.horizontalEdges.equalTo(self.view.safeAreaLayoutGuide).inset(hInset)
        }
        
        self.view.addSubview(self.completeButton)
        self.completeButton.snp.makeConstraints { make in
            make.top.equalTo(self.nicknameTextField.snp.bottom).offset(vOffset)
            make.horizontalEdges.equalTo(self.view.safeAreaLayoutGuide).inset(hInset)
        }
        
        self.nicknameTextField.setActionToTextField(valueChangeHandler: self.validateNickname(_:))
    }
}

extension ProfileEditViewController {
    private func randomizeProfileImage() {
        let randomNumber = (0..<12).randomElement() ?? 0
        let imageName = CHImageName.profilePrefix + String(randomNumber)
        self.selectedProfileImageView.configureImage(name: imageName)
    }
    
    private func validateNickname(_ input: String) {
        let validNicknameLengthRange = (2..<10)
        let invalidCharacterSet = CharacterSet(arrayLiteral: "@", "#", "$", "%")
        
        guard validNicknameLengthRange.contains(input.count) else {
            presentValidationResult(.invalid(.invalidLength))
            return
        }
        guard input.rangeOfCharacter(from: invalidCharacterSet) == nil else {
            presentValidationResult(.invalid(.invalidCharacter))
            return
        }
        
        guard input.rangeOfCharacter(from: CharacterSet.decimalDigits) == nil else {
            presentValidationResult(.invalid(.numberContained))
            return
        }
        presentValidationResult(.valid)
    }
    
    private func presentValidationResult(_ state: NicknameValidityState) {
        self.nicknameTextField.configureValidationResult(message: state.message)
        self.completeButton.isEnabled = state.isEnabled
    }
    
    private func setNickname(_ nickname: String) {
        self.nicknameTextField.setNickname(nickname)
        validateNickname(nickname)
    }
}
 
#Preview {
    let vc = ProfileEditViewController()
    return NavigationController(rootViewController: vc)
}

enum NicknameValidityState {
    enum InvalidState {
        case invalidLength
        case invalidCharacter
        case numberContained
        
        var message: String {
            switch self {
            case .invalidLength:
                return "2글자 이상 10글자 미만으로 설정해주세요"
            case .invalidCharacter:
                return "닉네임에 @, #, $, % 는 포함할 수 없어요"
            case .numberContained:
                return "닉네임에 숫자는 포함할 수 없어요"
            }
        }
    }
    
    case valid
    case invalid(_ state: InvalidState)
    
    var message: String {
        switch self {
        case .valid:
            return ""
        case .invalid(let state):
            return state.message
        }
    }
    
    var isEnabled: Bool {
        switch self {
        case .valid:
            return true
        case .invalid:
            return false
        }
    }
}
