//
//  SettingViewController.swift
//  CineHive
//
//  Created by Effie on 1/29/25.
//

import UIKit

final class SettingViewController: BaseViewController {
    @UserDefault(key: UserDefaultKey.userProfile)
    private var userProfile: ProfileInfo!
    
    private let menuList = [
        "자주 묻는 질문",
        "1:1 문의",
        "알림 설정",
        "탈퇴하기",
    ]
    
    private lazy var profileInfoView = ProfileInfoView(tapHandler: self.goToProfileSetting)
    
    private lazy var menuTableView = UITableView(frame: .zero)

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
    }
    
    private func configureViews() {
        self.view.addSubview(self.profileInfoView)
        self.profileInfoView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide).inset(10)
            make.horizontalEdges.equalTo(self.view.safeAreaLayoutGuide).inset(16)
            make.height.equalTo(self.view.safeAreaLayoutGuide).multipliedBy(0.2)
        }
        
        self.view.addSubview(self.menuTableView)
        self.menuTableView.snp.makeConstraints { make in
            make.top.equalTo(self.profileInfoView.snp.bottom).offset(16)
            make.horizontalEdges.equalTo(self.view.safeAreaLayoutGuide).inset(20)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide)
        }
        
        self.title = "설정"
        
        self.menuTableView.registerCellClass(MenuListTableViewCell.self)
        self.menuTableView.dataSource = self
        self.menuTableView.delegate = self
        
        self.menuTableView.rowHeight = self.view.frame.height / 20
        self.menuTableView.backgroundColor = .clear
        self.menuTableView.separatorStyle = .singleLine
        self.menuTableView.separatorColor = CHColor.primaryText.withAlphaComponent(0.5)
        self.menuTableView.separatorInset = .zero
    }
    
    private func goToProfileSetting() {
        let viewController = NavigationController(rootViewController: ProfileEditViewController())
        self.present(viewController, animated: true)
    }
    
    private func askForWithdraw() {
        let alert = UIAlertController(
            title: "탈퇴하기",
            message: "탈퇴를 하면 데이터가 모두 초기화됩니다.\n탈퇴 하시겠습니까?",
            preferredStyle: .alert
        )
        
        let okAction = UIAlertAction(title: "확인", style: .destructive) { _ in self.withdraw() }
        let cancelAction = UIAlertAction(title: "취소", style: .default)
        
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true)
    }
    
    private func withdraw() {
        self.userProfile = nil
        let destination = NavigationController(rootViewController: OnboardingViewController())
        replaceWindowRoot(to: destination)
    }
}

extension SettingViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
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
    
    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        tableView.deselectRow(at: indexPath, animated: false)
        switch indexPath.row {
        case 3:
            askForWithdraw()
        default:
            return
        }
    }
}
