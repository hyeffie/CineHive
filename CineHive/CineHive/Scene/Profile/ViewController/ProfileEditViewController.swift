//
//  ProfileEditViewController.swift
//  CineHive
//
//  Created by Effie on 1/24/25.
//

import UIKit

final class ProfileEditViewController: BaseViewController {
//    @UserDefault(key: UserDefaultKey.userProfile)
//    private var userProfile: ProfileInfo?
//    
//    private lazy var form: ProfileInfoForm = {
//        if let userProfile {
//            return ProfileInfoForm(
//                imageNumber: userProfile.imageNumber,
//                nickname: userProfile.nickname
//            )
//        } else {
//            return ProfileInfoForm()
//        }
//    }()
    
    private let viewModel: ProfileEditViewModel
    
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
    
    init(viewModel: ProfileEditViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        setForm()
    }
}

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
        
        switch self.viewModel.mode.value {
        case .create:
            self.navigationItem.title = "프로필 설정"
            
            self.view.addSubview(self.completeButton)
            self.completeButton.snp.makeConstraints { make in
                make.top.equalTo(self.nicknameTextField.snp.bottom).offset(vOffset)
                make.horizontalEdges.equalTo(self.view.safeAreaLayoutGuide).inset(hInset)
            }
        case .update:
            self.navigationItem.title = "프로필 편집"
            
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
        self.viewModel.setForm.value = ()
    }
}

extension ProfileEditViewController {
    private func validateNickname(_ input: String) {
        self.viewModel.nicknameTextFieldInput.value = input
    }
    
    private func presentValidationResult(_ state: NicknameValidityState) {
        self.nicknameTextField.configureValidationResult(message: state.message ?? "")
        self.completeButton.isEnabled = state.isEnabled
        self.navigationItem.rightBarButtonItem?.isEnabled = state.isEnabled
    }
}

extension ProfileEditViewController {
    private func goToProfileImageSelectScene() {
        guard let imageNumber = self.viewModel.profileImageNumber.value else {
            return
        }
        let viewController = ProfileImageViewController(
            selectedImageNumber: imageNumber,
            imageSelectionHandler: { [weak self] number in self?.setImage(number: number) }
        )
        self.push(viewController)
    }
    
    private func setImage(number: Int) {
        self.selectedProfileImageView.configureImage(number: number)
    }
}

extension ProfileEditViewController {
    private func saveProfile() {
        self.viewModel.saveButtonTapped.value = ()
    }
    
    private func resignScene() {
        switch self.viewModel.mode.value {
        case .create:
            self.replaceWindowRoot(to: TabBarController())
        case .update:
            self.dismiss(animated: true)
        }
    }
}
