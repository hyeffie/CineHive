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
    
    private let networkRequester = NetworkManager()
    
    private var trendingMovies: [MovieSummary] = []
    
    private lazy var profileInfoView = ProfileInfoView(tapHandler: self.goToProfileSetting)
    
    private lazy var recentQueryList = SectionedView(
        title: "최근 검색어",
        accessoryButtonInfo: ("전체 삭제", { [weak self] _ in self?.deleteAllSubmittedQueries() }),
        content: ScrollableHStack(spacing: 6, horizontalContentInset: 16),
        contentUnavailableMessage: "최근 검색어 내역이 없습니다."
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
        addNotificationObserver()
        fetchRecentQuery()
        getTrendingMovies()
    }
    
    private func fetchRecentQuery() {
        let sortedQueries = self.userProfile.submittedQueries.sorted { $0.submittedDate > $1.submittedDate }
        let contentIsAvailable = !sortedQueries.isEmpty
        self.recentQueryList.toggleContentAvailability(isAvailable: contentIsAvailable)
        let queryViews = sortedQueries.map { submittedQuery in
            SubmittedQueryView(
                query: submittedQuery.query,
                tapHandler: { [weak self] query in self?.goToSearch(query: query) },
                deleteHandler: { [weak self] query in self?.deleteSubmittedQuery(query) }
            )
        }
        self.recentQueryList.content.addViews(queryViews)
    }
    
    private func deleteSubmittedQuery(_ query: String) {
        let target = SubmittedQuery(submittedDate: .now, query: query)
        self.userProfile.submittedQueries.remove(target)
        notifySubmittedQueriesMutated()
    }
    
    private func deleteAllSubmittedQueries() {
        self.userProfile.submittedQueries.removeAll()
        notifySubmittedQueriesMutated()
    }
    
    private func notifySubmittedQueriesMutated() {
        NotificationCenter.default.post(name: CHNotification.userSubmittedQueryMutated, object: nil)
    }
    
    private func getTrendingMovies() {
        self.networkRequester.getTrendingMovies(
            successHandler: { [weak self] response in
                self?.handleResponse(response: response)
            },
            failureHandler: { [weak self] networkError in
                self?.handleError(networkError)
            }
        )
    }
    
    private func handleResponse(response: TrendingMovieResponse) {
        self.trendingMovies = response.movies
        let contentIsAvailable = !self.trendingMovies.isEmpty
        self.todayFeaturedMovieList.toggleContentAvailability(isAvailable: contentIsAvailable)
        self.todayFeaturedMovieList.content.reloadData()
    }
    
    private func handleError(_ error: Error) {
        if let presentableError = error as? PresentableError {
            presentErrorAlert(message: presentableError.message)
        }
    }
    
    private func todayMovieCollectionViewLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        let itemWidth = self.view.frame.width * 0.55
        layout.itemSize = CGSize.init(width: itemWidth, height: itemWidth * 1.67)
        layout.minimumInteritemSpacing = 16
        layout.minimumLineSpacing = 16
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
        }
        
        self.recentQueryList.content.snp.makeConstraints { make in
            make.height.equalTo(40)
        }
        
        self.view.addSubview(self.todayFeaturedMovieList)
        // 오늘의 영화 섹션은 남은 영역을 기준으로
        self.todayFeaturedMovieList.snp.makeConstraints { make in
            make.top.equalTo(self.recentQueryList.snp.bottom).offset(spacing)
            make.horizontalEdges.equalTo(self.view.safeAreaLayoutGuide)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide)
        }
        self.todayFeaturedMovieList.content.setContentHuggingPriority(.defaultLow, for: .vertical)
        
        self.title = "CineHive"
        configureTodayMovieCollectionView()
        
        let searchButton = UIBarButtonItem(systemItem: .search)
        self.navigationItem.setRightBarButton(searchButton, animated: false)
        searchButton.primaryAction = UIAction { _ in self.goToSearch() }
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
    
    private func goToSearch(query: String? = nil) {
        let viewController = SearchResultViewController(query: query)
        viewController.hidesBottomBarWhenPushed = true
        self.push(viewController)
    }
    
    private func goToDetail(summary: MovieSummary) {
        let detail = MovieDetail(
            id: summary.id,
            title: summary.title,
            releaseDate: summary.releaseDate,
            voteAverage: summary.voteAverage,
            genreIDS: summary.genreIDS,
            overview: summary.overview,
            liked: findMovieIfLiked(movieID: summary.id)
        )
        
        let viewController = MovieDetailViewController(movieDetail: detail)
        self.push(viewController)
    }
    
    private func toggleLike(movieID: Int) {
        if self.userProfile.likedMovieIDs.contains(movieID) {
            self.userProfile.likedMovieIDs.removeAll { id in id == movieID }
        } else {
            self.userProfile.likedMovieIDs.append(movieID)
        }
        notifyLikedMovieMutated()
    }
    
    private func findMovieIfLiked(movieID: Int) -> Bool {
        return self.userProfile.likedMovieIDs.contains(movieID)
    }
    
    private func notifyLikedMovieMutated() {
        NotificationCenter.default.post(name: CHNotification.userLikedMovieMutated, object: nil)
    }
    
    private func addNotificationObserver() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.updateLikes),
            name: CHNotification.userLikedMovieMutated,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.updateRecentQuerys),
            name: CHNotification.userSubmittedQueryMutated,
            object: nil
        )
    }
    
    @objc private func updateLikes() {
        self.todayFeaturedMovieList.content.reloadData()
    }
    
    @objc private func updateRecentQuerys() {
        self.fetchRecentQuery()
    }
}

extension MainViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return self.trendingMovies.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell: FeaturedMovieCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath) else {
            return UICollectionViewCell()
        }
        let target = self.trendingMovies[indexPath.row]
        let movieSummary = FeaturedMovieSummary(
            id: target.id,
            posterImageURL: TMDBImage.w500(target.posterPath ?? "").url,
            title: target.title,
            synopsys: target.overview ?? "",
            liked: findMovieIfLiked(movieID: target.id)
        )
        cell.configure(
            movieSummary: movieSummary,
            likeButtonAction: { movieID in self.toggleLike(movieID: movieID) }
        )
        return cell
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        let targetSummary = self.trendingMovies[indexPath.item]
        goToDetail(summary: targetSummary)
    }
}
