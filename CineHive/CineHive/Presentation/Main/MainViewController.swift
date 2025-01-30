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
        let itemWidth = self.view.frame.width / 7 * 4
        layout.itemSize = CGSize.init(width: itemWidth, height: itemWidth * (45 / 27))
        layout.minimumInteritemSpacing = 10
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
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
        configureTodayMovieCollectionView()
    }
    
    private func configureTodayMovieCollectionView() {
        let collectionView = self.todayFeaturedMovieList.content
        
        collectionView.registerCellClass(FeaturedMovieCollectionViewCell.self)
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
    }
    
    private func goToProfileSetting() {
        let viewController = NavigationController(rootViewController: ProfileEditViewController())
        self.present(viewController, animated: true)
    }
}

extension MainViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return 10
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell: FeaturedMovieCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath) else {
            return UICollectionViewCell()
        }
        let targetMovie = FeaturedMovieSummary(
            posterImageURL: URL(string: "https://cdn.sisain.co.kr/news/photo/201906/34919_67998_0853.jpg"),
            title: "기생충",
            synopsys: "이 사진은 이른바 만들어진 사진, 메이킹 포토(Making Photo)의 일종이며 분위기는 포스트모던하다. 실제로 연출 사진 혹은 메이킹 포토는 사진계에서는 대세가 된 지 오래다. 이 사진이 여러 장의 사진을 몽타주해서 만들어졌음은 두 말할 필요도 없다. 우선 인물과 사물에 따라 빛의 방향이 다르다.",
            liked: true
        )
        cell.configure(
            movieSummary: targetMovie,
            likeButtonAction: { liked in print(liked) }
        )
        return cell
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        print(#function)
    }
}
