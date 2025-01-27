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
    }
}
 
#Preview {
    let vc = ProfileEditViewController()
    return NavigationController(rootViewController: vc)
}
