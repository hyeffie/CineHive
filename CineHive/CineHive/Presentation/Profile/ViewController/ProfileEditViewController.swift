//
//  ProfileEditViewController.swift
//  CineHive
//
//  Created by Effie on 1/24/25.
//

import UIKit

final class ProfileEditViewController: BaseViewController {
    @UserDefault(key: UserDefaultKey.userProfile)
    private var userProfile: ProfileInfo?
    
    private lazy var form: ProfileInfoForm = {
        if let userProfile {
            return ProfileInfoForm(
                imageNumber: userProfile.imageNumber,
                nickname: userProfile.nickname
            )
        } else {
            return ProfileInfoForm()
        }
    }()
    
    private lazy var selectedProfileImageView = SelectedProfileImageView(
        imageName: nil,
        tapHandler: { [weak self] in self?.goToProfileImageSelectScene() }
    )
    
    private let nicknameTextField = NicknameTextField()
    
    private lazy var completeButton = {
        let button = ThemePillShapeButton(title: "완료")
        let action = UIAction { [weak self] _ in self?.saveProfile() }
        button.addAction(action, for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        setForm()
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
        
        if userProfile == nil {
            self.title = "프로필 설정"
            
            self.view.addSubview(self.completeButton)
            self.completeButton.snp.makeConstraints { make in
                make.top.equalTo(self.nicknameTextField.snp.bottom).offset(vOffset)
                make.horizontalEdges.equalTo(self.view.safeAreaLayoutGuide).inset(hInset)
            }
        } else {
            self.title = "프로필 편집"
            
            let dismissAction = UIAction { [weak self] _ in self?.dismiss(animated: true) }
            let dismissButton = UIBarButtonItem(image: CHSymbol.xmark.value, primaryAction: dismissAction)
            self.navigationItem.setLeftBarButton(dismissButton, animated: false)
            
            let action = UIAction { [weak self] _ in self?.saveProfile() }
            let saveButton = UIBarButtonItem(title: "저장", primaryAction: action)
            self.navigationItem.setRightBarButton(saveButton, animated: false)
        }
        
        self.nicknameTextField.setActionToTextField(valueChangeHandler: self.validateNickname(_:))
    }
    
    private func setForm() {
        self.selectedProfileImageView.configureImage(number: self.form.imageNumber)
        self.nicknameTextField.setNickname(self.form.nickname)
        let _ = validateNickname(self.form.nickname)
    }
}

extension ProfileEditViewController {
    private func validateNickname(_ input: String) -> String? {
        let validNicknameLengthRange = (2..<10)
        guard validNicknameLengthRange.contains(input.count) else {
            presentValidationResult(.invalid(.invalidLength))
            return nil
        }
        
        let invalidCharacterSet = CharacterSet(arrayLiteral: "@", "#", "$", "%")
        guard input.rangeOfCharacter(from: invalidCharacterSet) == nil else {
            presentValidationResult(.invalid(.invalidCharacter))
            return nil
        }
        
        let numberCharacterSet = CharacterSet.decimalDigits
        guard input.rangeOfCharacter(from: numberCharacterSet) == nil else {
            presentValidationResult(.invalid(.numberContained))
            return nil
        }
        presentValidationResult(.valid(nickname: input))
        return input
    }
    
    private func presentValidationResult(_ state: NicknameValidityState) {
        self.nicknameTextField.configureValidationResult(message: state.message)
        self.completeButton.isEnabled = state.isEnabled
        self.navigationItem.rightBarButtonItem?.isEnabled = state.isEnabled
        if case .valid(let nickname) = state { self.form.nickname = nickname }
    }
}

extension ProfileEditViewController {
    private func goToProfileImageSelectScene() {
        let viewController = ProfileImageViewController(
            selectedImageNumber: self.form.imageNumber,
            imageSelectionHandler: { [weak self] number in self?.setImage(number: number) }
        )
        self.push(viewController)
    }
    
    private func setImage(number: Int) {
        self.form.imageNumber = number
        self.selectedProfileImageView.configureImage(number: number)
    }
}

extension ProfileEditViewController {
    private func saveProfile() {
        let isSignUp = self.userProfile == nil
        
        let newUserProfile = ProfileInfo(
            imageNumber: self.form.imageNumber,
            nickname: self.form.nickname,
            createdAt: self.userProfile?.createdAt ?? .now,
            likedMovieIDs: self.userProfile?.likedMovieIDs ?? []
        )
        
        self.userProfile = newUserProfile
        
        if isSignUp {
            self.replaceWindowRoot(to: TabBarController())
        } else {
            nofifyUserProfileUpdate()
            self.dismiss(animated: true)
        }
    }
    
    private func nofifyUserProfileUpdate() {
        NotificationCenter.default.post(name: CHNotification.userProfileUpdated, object: nil)
    }
}
