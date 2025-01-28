//
//  ProfileEditViewController.swift
//  CineHive
//
//  Created by Effie on 1/24/25.
//

import UIKit

final class ProfileEditViewController: BaseViewController {
    private lazy var selectedImageNumber: Int = self.randomizeProfileImageNumber()
    
    private lazy var selectedProfileImageView = SelectedProfileImageView(
        imageName: nil,
        tapHandler: { [weak self] in self?.goToProfileImageSelectScene() }
    )
    
    private let nicknameTextField = NicknameTextField()
    
    private let completeButton = ThemePillShapeButton(title: "완료")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "프로필 설정"
        
        configureView()
        
        setProfileImage()
        setNickname("")
    }
    
    private func goToProfileImageSelectScene() {
        let viewController = ProfileImageViewController(
            selectedImageNumber: self.selectedImageNumber,
            imageSelectionHandler: { [weak self] number in self?.setImage(number: number) }
        )
        self.push(viewController)
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
    private func randomizeProfileImageNumber() -> Int {
        return (0..<12).randomElement() ?? 0
    }
    
    private func setProfileImage() {
        self.selectedProfileImageView.configureImage(number: self.selectedImageNumber)
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
    
    private func setImage(number: Int) {
        self.selectedImageNumber = number
        self.selectedProfileImageView.configureImage(number: number)
    }
}
 
#Preview {
    let vc = ProfileEditViewController()
    return NavigationController(rootViewController: vc)
}
