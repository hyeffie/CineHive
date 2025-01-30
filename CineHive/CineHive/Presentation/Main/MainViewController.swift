//
//  MainViewController.swift
//  CineHive
//
//  Created by Effie on 1/30/25.
//

import UIKit

final class MainViewController: BaseViewController {
    @UserDefault(key: UserDefaultKey.userProfile)
    private var userProfile: ProfileInfo!
    
    private lazy var profileInfoView = ProfileInfoView(tapHandler: self.goToProfileSetting)
    
    private lazy var recentQueryList = SectionedView(
        title: "최근 검색어",
        accessoryButtonInfo: ("전체 삭제", {}),
        content: UIView()
    )
    
    private lazy var todayFeaturedMovieList = SectionedView(
        title: "오늘의 영화",
        content: UICollectionView(
            frame: .zero,
            collectionViewLayout: self.todayMovieCollectionViewLayout()
        )
    )
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
    }
    
    private func todayMovieCollectionViewLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        return layout
    }
    
    private func configureViews() {
        let spacing = 8
        
        self.view.addSubview(self.profileInfoView)
        self.profileInfoView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide).inset(10)
            make.horizontalEdges.equalTo(self.view.safeAreaLayoutGuide).inset(16)
            make.height.equalTo(self.view.safeAreaLayoutGuide).multipliedBy(0.2)
        }
        
        self.view.addSubview(self.recentQueryList)
        // 최근 검색어 섹션은 intrinsic size를 기준으로
        self.recentQueryList.snp.makeConstraints { make in
            make.top.equalTo(self.profileInfoView.snp.bottom).offset(spacing)
            make.horizontalEdges.equalTo(self.view.safeAreaLayoutGuide)
            
            // 임시 코드
            make.height.equalTo(100)
        }
        
        self.view.addSubview(self.todayFeaturedMovieList)
        // 오늘의 영화 섹션은 남은 영역을 기준으로
        self.todayFeaturedMovieList.snp.makeConstraints { make in
            make.top.equalTo(self.recentQueryList.snp.bottom).offset(spacing)
            make.horizontalEdges.bottom.equalTo(self.view.safeAreaLayoutGuide)
        }
        
        self.title = "CineHive"
        self.todayFeaturedMovieList.content.backgroundColor = .clear
    }
    
    private func goToProfileSetting() {
        let viewController = NavigationController(rootViewController: ProfileEditViewController())
        self.present(viewController, animated: true)
    }
}
