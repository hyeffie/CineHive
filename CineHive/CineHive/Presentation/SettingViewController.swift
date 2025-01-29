//
//  SettingViewController.swift
//  CineHive
//
//  Created by Effie on 1/29/25.
//

import UIKit

final class SettingViewController: BaseViewController {
    private let profileInfo: ProfileInfo
    
    private lazy var profileInfoView = ProfileInfoView(
        profileInfo: self.profileInfo,
        tapHandler: self.goToProfileSetting
    )
    
    init(profileInfo: ProfileInfo) {
        self.profileInfo = profileInfo
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
    }
    
    private func configureViews() {
        self.view.addSubview(self.profileInfoView)
        self.profileInfoView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(self.view.safeAreaLayoutGuide).inset(12)
            make.height.equalTo(self.view.safeAreaLayoutGuide).multipliedBy(0.2)
        }
    }
    
    private func goToProfileSetting() {
        let viewController = ProfileEditViewController()
        self.push(viewController)
    }
}

#Preview {
    let viewController = SettingViewController(profileInfo: .init(nickname: "Effie"))
    NavigationController(rootViewController: viewController)
}
