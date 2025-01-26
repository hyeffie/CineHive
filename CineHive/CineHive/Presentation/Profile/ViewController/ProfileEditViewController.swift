//
//  ProfileEditViewController.swift
//  CineHive
//
//  Created by Effie on 1/24/25.
//

import UIKit

final class ProfileEditViewController: UIViewController {
    private let selectedProfileImageView = SelectedProfileImageView(imageName: nil)
    
    private let nicknameTextField = NicknameTextField()
    
    private let validationResultLabel = {
        let label = UILabel()
        label.textColor = CHColor.theme
        label.font = CHFont.small
        return label
    }()
    
    private let completeButton = ThemePillShapeButton(title: "완료")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "프로필 설정"
        
        configureView()
    }
}

// MARK: - Configuring Views
extension ProfileEditViewController {
    private func configureView() {
        self.view.addSubview(self.selectedProfileImageView)
        self.view.addSubview(self.nicknameTextField)
        self.view.addSubview(self.validationResultLabel)
        self.view.addSubview(self.completeButton)
        
        self.selectedProfileImageView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide).offset(30)
            make.centerX.equalTo(self.view.safeAreaLayoutGuide)
            make.width.equalTo(self.view.safeAreaLayoutGuide).multipliedBy(0.25)
        }
        
        self.nicknameTextField.snp.makeConstraints { make in
            make.top.equalTo(self.selectedProfileImageView.snp.bottom).offset(20)
            make.horizontalEdges.equalTo(self.view.safeAreaLayoutGuide).inset(16)
            make.height.equalTo(self.view.safeAreaInsets).multipliedBy(0.3)
        }
        
        self.validationResultLabel.snp.makeConstraints { make in
            make.top.equalTo(self.nicknameTextField.snp.bottom).offset(20)
            make.leading.equalTo(self.nicknameTextField).offset(16)
        }
        
        self.completeButton.snp.makeConstraints { make in
            make.top.equalTo(self.validationResultLabel.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(self.view.safeAreaLayoutGuide).inset(20)
        }
    }
}

#Preview {
    let vc = ProfileEditViewController()
    return NavigationController(rootViewController: vc)
}
