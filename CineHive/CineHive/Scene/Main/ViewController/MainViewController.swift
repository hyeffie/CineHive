//
//  MainViewController.swift
//  CineHive
//
//  Created by Effie on 1/30/25.
//

import UIKit

final class MainViewController: BaseViewController {
    private enum ContentState: ContenUnavailableState {
        case noSearchQuery
        case noTrendingMovies
        
        var displayingMessage: String {
            switch self {
            case .noSearchQuery: return "최근 검색어 내역이 없습니다."
            case .noTrendingMovies: return "추천 영화가 없습니다."
            }
        }
    }
    
    private let viewModel: MainViewModel
    
    private lazy var profileInfoView = {
        let viewModel = ProfileInfoViewModel(profileManager: UserProfileManager())
        return ProfileInfoView(viewModel: viewModel, tapHandler: self.goToProfileSetting)
    }()
    
    private let queryStack = ScrollableHStack(spacing: 6, horizontalContentInset: 16)
    
    private let querySection = SectionView(contentHeight: 40)
    
    private lazy var trendingCollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: self.todayMovieCollectionViewLayout()
    )
    
    private let trendingSection = SectionView()
    
    init(viewModel: MainViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        bind()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
    }
    
    private func bind() {
        self.viewModel.output.sumittedQuries.bind { [weak self] queries in
            self?.updateRecentQueries(queries)
        }
        
        self.viewModel.output.trendingMovieSummaries.lazyBind { [weak self] movies in
            self?.updateMovies(movies)
        }
        
        self.viewModel.output.goToProfileEdit.lazyBind { [weak self] _ in
            self?.goToProfileSetting()
        }
        
        self.viewModel.output.goToSearch.lazyBind { [weak self] query in
            self?.goToSearch(query: query)
        }
        
        self.viewModel.output.goToDetail.lazyBind { [weak self] detail in
            guard let detail else { return }
            self?.goToDetail(detail: detail)
        }
        
        self.viewModel.output.errorMessage.lazyBind { [weak self] message in
            guard let message else { return }
            self?.presentErrorAlert(message: message)
        }
    }
}

extension MainViewController {
    private func deleteSubmittedQuery(_ query: String) {
        self.viewModel.input.deleteQueryButtonTapped.value = query
    }
    
    private func deleteAllSubmittedQueries() {
        self.viewModel.input.deleteAllQueriesButtonTapped.value = ()
    }
}

extension MainViewController {
    private func updateRecentQueries(_ queries: [SubmittedQuery]) {
        let contentIsAvailable = !queries.isEmpty
        self.querySection.contentIsAvailable = contentIsAvailable ? .available : .unavailable(ContentState.noSearchQuery)
        let queryViews = queries.map { submittedQuery in
            SubmittedQueryView(
                query: submittedQuery.query,
                tapHandler: { [weak self] query in self?.goToSearch(query: query) },
                deleteHandler: { [weak self] query in self?.deleteSubmittedQuery(query) }
            )
        }
        self.queryStack.addViews(queryViews)
    }
    
    private func updateMovies(_ movies: [FeaturedMovieSummary]) {
        let contentIsAvailable = !movies.isEmpty
        self.trendingSection.contentIsAvailable = contentIsAvailable ? .available : .unavailable(ContentState.noTrendingMovies)
        self.trendingCollectionView.reloadData()
    }
}

extension MainViewController {
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
        let spacing = 12
        
        self.view.addSubview(self.profileInfoView)
        self.profileInfoView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide).inset(10)
            make.horizontalEdges.equalTo(self.view.safeAreaLayoutGuide).inset(16)
            make.height.equalTo(self.view.safeAreaLayoutGuide).multipliedBy(0.2)
        }
        
        self.view.addSubview(self.querySection)
        // 최근 검색어 섹션은 intrinsic size를 기준으로
        self.querySection.snp.makeConstraints { make in
            make.top.equalTo(self.profileInfoView.snp.bottom).offset(spacing)
            make.horizontalEdges.equalTo(self.view.safeAreaLayoutGuide)
        }
        
        self.querySection.contentView?.snp.makeConstraints { make in
            make.height.equalTo(40)
        }
        
        self.view.addSubview(self.trendingSection)
        // 오늘의 영화 섹션은 남은 영역을 기준으로
        self.trendingSection.snp.makeConstraints { make in
            make.top.equalTo(self.querySection.snp.bottom).offset(spacing)
            make.horizontalEdges.equalTo(self.view.safeAreaLayoutGuide)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide)
        }
        self.trendingCollectionView.setContentHuggingPriority(.defaultLow, for: .vertical)
        
        configureNavigationBar()
        configureTrendingCollectionView()
        configureQuerySection()
        configureTrendingSection()
    }
    
    private func configureNavigationBar() {
        self.navigationItem.title = "CineHive"
        let searchButton = UIBarButtonItem(systemItem: .search)
        self.navigationItem.setRightBarButton(searchButton, animated: false)
        searchButton.primaryAction = UIAction { _ in self.goToSearch() }
    }
    
    private func configureQuerySection() {
        self.querySection.setTitle("최근 검색어")
        let action = UIAction(handler: { [weak self] action in
            self?.deleteAllSubmittedQueries()
        })
        self.querySection.setAccessoryButton(title: "모두 삭제", action: action)
        self.querySection.setContentView(self.queryStack)
    }
    
    private func configureTrendingCollectionView() {
        self.trendingCollectionView.registerCellClass(FeaturedMovieCollectionViewCell.self)
        self.trendingCollectionView.dataSource = self
        self.trendingCollectionView.delegate = self
        self.trendingCollectionView.backgroundColor = .clear
        self.trendingCollectionView.showsVerticalScrollIndicator = false
        self.trendingCollectionView.showsHorizontalScrollIndicator = false
    }
    
    private func configureTrendingSection() {
        self.trendingSection.setTitle("오늘의 영화")
        self.trendingSection.setContentView(self.trendingCollectionView)
    }
}

extension MainViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return self.viewModel.output.trendingMovieSummaries.value.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell: FeaturedMovieCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath) else {
            return UICollectionViewCell()
        }
        let movieSummary = self.viewModel.output.trendingMovieSummaries.value[indexPath.item]
        cell.configure(
            movieSummary: movieSummary,
            likeButtonAction: { [weak self] movieID in
                self?.viewModel.input.likeButtonTappedForMovieID.value = movieID
            }
        )
        return cell
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        collectionView.deselectItem(at: indexPath, animated: true)
        self.viewModel.input.didSelectCellAtIndex.value = indexPath.item
    }
}

extension MainViewController {
    private func goToProfileSetting() {
        let viewModel = ProfileEditViewModel(mode: .update)
        let viewController = NavigationController(rootViewController: ProfileEditViewController(viewModel: viewModel))
        self.present(viewController, animated: true)
    }
    
    private func goToSearch(query: String? = nil) {
        let viewController = SearchResultViewController(query: query)
        self.push(viewController)
    }
    
    private func goToDetail(detail: MovieDetail) {
        let viewController = MovieDetailViewController(movieDetail: detail)
        self.push(viewController)
    }
}
