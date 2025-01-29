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
    
    private lazy var menuTableView = UICollectionView(
        frame: .zero,
        collectionViewLayout: self.collectionViewLayout()
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
    
    private func collectionViewLayout() -> UICollectionViewLayout {
        let outerInset: CGFloat = 12
        let layout = UICollectionViewFlowLayout()
        let superViewWidth = self.view.safeAreaLayoutGuide.layoutFrame.width - (outerInset * 2)
        let superViewHeight = self.view.safeAreaLayoutGuide.layoutFrame.height
        layout.itemSize = CGSize(width: superViewWidth, height: superViewHeight / 15)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        return layout
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
        
        self.menuTableView.registerCellClass(MenuListCollectionViewCell.self)
        self.menuTableView.dataSource = self
        self.menuTableView.delegate = self
        self.menuTableView.backgroundColor = .clear
    }
    
    private func goToProfileSetting() {
        let viewController = ProfileEditViewController()
        self.push(viewController)
    }
    
    private func withdraw() {
        
    }
}

extension SettingViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return self.menuList.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard
            let cell: MenuListCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
        else { return UICollectionViewCell() }
        cell.configure(title: self.menuList[indexPath.row])
        return cell
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        switch indexPath.row {
        case 3:
            withdraw()
        default:
            return
        }
    }
}

#Preview {
    let viewController = SettingViewController(profileInfo: .init(nickname: "Effie"))
    NavigationController(rootViewController: viewController)
}
