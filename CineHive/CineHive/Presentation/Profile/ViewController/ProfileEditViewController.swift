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
        let action = UIAction { [weak self] _ in self?.signUp() }
        button.addAction(action, for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        
        setForm()
    }
    
    private func goToProfileImageSelectScene() {
        let viewController = ProfileImageViewController(
            selectedImageNumber: self.form.imageNumber,
            imageSelectionHandler: { [weak self] number in self?.setImage(number: number) }
        )
        self.push(viewController)
    }
    
    private func signUp() {
        let isSignUp = self.userProfile == nil
        
        // 현재 입력된 정보 validation
        validateNickname(self.form.nickname)
        
        // 새로운 user profile 생성
        let newUserProfile = ProfileInfo(
            imageNumber: self.form.imageNumber,
            nickname: self.form.nickname,
            createdAt: self.userProfile?.createdAt ?? .now,
            likedMovieIDs: self.userProfile?.likedMovieIDs ?? []
        )
        
        // 현재 입력된 정보 user defaults 에 저장
        self.userProfile = newUserProfile
        
        // 화면 전환
        if isSignUp {
            // TODO: 탭바 컨트롤러로 교체
        } else {
            self.dismiss(animated: true)
        }
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
        
        if let userProfile {
            self.title = "프로필 편집"
            let dismissAction = UIAction { [weak self] _ in self?.dismiss(animated: true) }
            let dismissButton = UIBarButtonItem(image: CHSymbol.xmark.value, primaryAction: dismissAction)
            self.navigationItem.setLeftBarButton(dismissButton, animated: false)
            
            let action = UIAction { [weak self] _ in self?.signUp() }
            let saveButton = UIBarButtonItem(title: "저장", primaryAction: action)
            self.navigationItem.setRightBarButton(saveButton, animated: false)
        } else {
            self.title = "프로필 설정"
            
            self.view.addSubview(self.completeButton)
            self.completeButton.snp.makeConstraints { make in
                make.top.equalTo(self.nicknameTextField.snp.bottom).offset(vOffset)
                make.horizontalEdges.equalTo(self.view.safeAreaLayoutGuide).inset(hInset)
            }
        }
        
        self.nicknameTextField.setActionToTextField(valueChangeHandler: self.validateNickname(_:))
    }
}

extension ProfileEditViewController {
    private func setForm() {
        self.selectedProfileImageView.configureImage(number: self.form.imageNumber)
        self.nicknameTextField.setNickname(self.form.nickname)
        validateNickname(self.form.nickname)
    }
    
    private func setImage(number: Int) {
        self.form.imageNumber = number
        self.selectedProfileImageView.configureImage(number: number)
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
}
