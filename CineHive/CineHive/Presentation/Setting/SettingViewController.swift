//
//  SettingViewController.swift
//  CineHive
//
//  Created by Effie on 1/29/25.
//

import UIKit

final class SettingViewController: BaseViewController {
    private let profileInfo: ProfileInfo
    
    private let menuList = [
        "자주 묻는 질문",
        "1:1 문의",
        "알림 설정",
        "탈퇴하기",
    ]
    
    private lazy var profileInfoView = ProfileInfoView(
        profileInfo: self.profileInfo,
        tapHandler: self.goToProfileSetting
    )
    
    private lazy var menuTableView = UITableView(frame: .zero)
    
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
        let outerInset: CGFloat = 12
        self.view.addSubview(self.profileInfoView)
        self.profileInfoView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(self.view.safeAreaLayoutGuide).inset(outerInset)
            make.height.equalTo(self.view.safeAreaLayoutGuide).multipliedBy(0.2)
        }
        
        self.view.addSubview(self.menuTableView)
        self.menuTableView.snp.makeConstraints { make in
            make.top.equalTo(self.profileInfoView.snp.bottom).offset(outerInset)
            make.horizontalEdges.equalTo(self.view.safeAreaLayoutGuide).inset(outerInset)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide)
        }
        
        self.menuTableView.registerCellClass(MenuListTableViewCell.self)
        self.menuTableView.dataSource = self
        self.menuTableView.delegate = self
        
        self.menuTableView.rowHeight = self.view.frame.height / 15
        self.menuTableView.backgroundColor = .clear
        self.menuTableView.separatorStyle = .singleLine
        self.menuTableView.separatorColor = CHColor.primaryText.withAlphaComponent(0.6)
        self.menuTableView.separatorInset = .zero
    }
    
    private func goToProfileSetting() {
        let viewController = ProfileEditViewController()
        self.push(viewController)
    }
    
    private func withdraw() {
        
    }
}

extension SettingViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.menuList.count
    }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        guard let cell: MenuListTableViewCell = tableView.dequeueReusableCell(for: indexPath) else { return UITableViewCell() }
        cell.configure(title: self.menuList[indexPath.row])
        return cell
    }
}

#Preview {
    let viewController = SettingViewController(profileInfo: .init(nickname: "Effie"))
    NavigationController(rootViewController: viewController)
}
