//
//  ProfileEditViewController.swift
//  CineHive
//
//  Created by Effie on 1/24/25.
//

import UIKit

final class ProfileEditViewController: BaseViewController {
    private let viewModel: ProfileEditViewModel
    
    private lazy var selectedProfileImageView = SelectedProfileImageView(
        imageName: nil,
        tapHandler: { [weak self] in self?.goToProfileImageSelectScene() }
    )
    
    private let nicknameTextField = NicknameTextField()
    
    private let mbtiSectionLabel = {
        let label = BaseLabel(font: CHFont.mediumBold)
        label.text = "MBTI"
        return label
    }()
    
    private lazy var mbtiStack = MBTIStack(delegate: self)
    
    private lazy var completeButton = {
        let button = ThemePillShapeButton(title: "완료")
        let action = UIAction { [weak self] _ in self?.saveProfile() }
        button.addAction(action, for: .touchUpInside)
        return button
    }()
    
    private let tapGestureRecognizer = UITapGestureRecognizer()
    
    init(viewModel: ProfileEditViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        bind()
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
    private func bind() {
        self.viewModel.output.profileImageNumber.lazyBind { [weak self] imageNumber in
            guard let imageNumber else { return }
            self?.setImage(number: imageNumber)
        }
        
        self.viewModel.output.nicknameFieldText.lazyBind { [weak self] nickname in
            self?.nicknameTextField.setNickname(nickname)
        }
        
        self.viewModel.output.nicknameValidationResultText.lazyBind { [weak self] resultText in
            self?.nicknameTextField.configureValidationResult(message: resultText)
        }
        
        self.viewModel.output.nicknameIsValid.lazyBind { [weak self] isValid in
            self?.nicknameTextField.configureValidationResult(isValid: isValid)
        }
        
        self.viewModel.output.resignScene.lazyBind { [weak self] _ in
            self?.resignScene()
        }
        
        self.viewModel.output.goToImageSelectScene.lazyBind { [weak self] _ in
            self?.goToProfileImageSelectScene()
        }
        
        self.viewModel.output.profileFormIsValid.lazyBind { [weak self] submittionIsValid in
            self?.completeButton.isEnabled = submittionIsValid
            self?.navigationItem.rightBarButtonItem?.isEnabled = submittionIsValid
        }
        
        self.viewModel.output.setMBTI.lazyBind { [weak self] mbti in
            self?.mbtiStack.setMBTI(mbti)
        }
        
        self.viewModel.output.resignKeyboard.lazyBind { [weak self] _ in
            self?.resignKeyboard()
        }
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
        
        self.view.addSubview(self.mbtiSectionLabel)
        self.mbtiSectionLabel.snp.makeConstraints { make in
            make.top.equalTo(self.nicknameTextField.snp.bottom).offset(vOffset)
            make.leading.equalTo(self.view.safeAreaLayoutGuide).offset(24)
        }
        
        self.view.addSubview(self.mbtiStack)
        self.mbtiStack.snp.makeConstraints { make in
            make.top.equalTo(self.mbtiSectionLabel)
            make.trailing.equalTo(self.view.safeAreaLayoutGuide).inset(24)
        }
        
        switch self.viewModel.output.mode.value {
        case .create:
            self.navigationItem.title = "프로필 설정"
            
            self.view.addSubview(self.completeButton)
            self.completeButton.snp.makeConstraints { make in
                make.bottom.equalTo(self.view.safeAreaLayoutGuide).inset(vOffset)
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
        self.nicknameTextField.delegate = self
        
        self.view.addGestureRecognizer(self.tapGestureRecognizer)
        self.tapGestureRecognizer.addTarget(self, action: #selector(self.tapGestureDidRecognize))
    }
    
    @objc private func tapGestureDidRecognize() {
        self.viewModel.input.tapGestureDidRecognize.value = ()
    }
}

extension ProfileEditViewController {
    private func setForm() {
        self.viewModel.input.setForm.value = ()
    }

    private func validateNickname(_ input: String) {
        self.viewModel.input.nicknameTextFieldInput.value = input
    }

    private func goToProfileImageSelectScene() {
        guard let imageNumber = self.viewModel.output.profileImageNumber.value else {
            return
        }
        let viewModel = ProfileImageViewModel(
            selectedImageNumber: imageNumber,
            imageSelectionHandler: { [weak self] number in
                self?.viewModel.input.setImageNumber.value = number
            }
        )
        let viewController = ProfileImageViewController(viewModel: viewModel)
        self.push(viewController)
    }
    
    private func setImage(number: Int) {
        self.selectedProfileImageView.configureImage(number: number)
    }

    private func saveProfile() {
        self.viewModel.input.saveButtonTapped.value = ()
    }
    
    private func resignScene() {
        switch self.viewModel.output.mode.value {
        case .create:
            self.replaceWindowRoot(to: TabBarController())
        case .update:
            self.dismiss(animated: true)
        }
    }
    
    private func resignKeyboard() {
        self.view.endEditing(true)
    }
}

extension ProfileEditViewController: MBTIStackDelegate {
    func didUpdateMBTI(_ mbti: MBTI) {
        self.viewModel.input.mbtiDidSelect.value = mbti
    }
}

extension ProfileEditViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.viewModel.input.keyboardReturnKeyTapped.value = ()
        return true
    }
}
