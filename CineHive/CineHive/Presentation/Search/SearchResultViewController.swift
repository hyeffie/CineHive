//
//  SearchResultViewController.swift
//  CineHive
//
//  Created by Effie on 1/31/25.
//

import UIKit

final class SearchResultViewController: BaseViewController {
    @UserDefault(key: UserDefaultKey.userProfile)
    private var userProfile: ProfileInfo!
    
    private var items: [SearchMovieSummary]
    
    private var latestQuery: String?
    
    private var currentPage: Int
    
    private var isLastPage: Bool
    
    private enum ContentAvailability {
        case beforeSearch
        case noResult
        case available
    }
    
    private var contentAvailability: ContentAvailability {
        didSet {
            setNeedsUpdateContentUnavailableConfiguration()
        }
    }
    
    private let tableView = UITableView(frame: .zero)
    
    init(query: String? = nil) {
        self.items = []
        self.latestQuery = query
        self.contentAvailability = .beforeSearch
        self.currentPage = 0
        self.isLastPage = false
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
    
    override func updateContentUnavailableConfiguration(using state: UIContentUnavailableConfigurationState) {
        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let self else { return }
            switch self.contentAvailability {
            case .beforeSearch:
                self.contentUnavailableConfiguration = SearchUnavailableConfiguration.beforeSearch
            case .noResult:
                self.contentUnavailableConfiguration = SearchUnavailableConfiguration.noSearchingResults
            case .available:
                self.contentUnavailableConfiguration = nil
            }
        }
    }
    
    private func configureViews() {
        self.title = "영화 검색"
        
        self.view.addSubview(self.tableView)
        self.tableView.snp.makeConstraints { make in
            make.edges.equalTo(self.view.safeAreaLayoutGuide)
        }
        
        configureSearchController()
        configureTableView()
    }
    
    private func configureSearchController() {
        let searchController = UISearchController(searchResultsController: nil)
        navigationItem.searchController = searchController
        searchController.searchBar.delegate = self
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.placeholder = "영화를 검색해보세요."
        searchController.searchBar.searchTextField.backgroundColor = CHColor.darkLabelBackground.withAlphaComponent(0.5)
        searchController.searchBar.searchTextField.textColor = CHColor.primaryText
        searchController.searchBar.searchTextField.clearButtonMode = .never
        searchController.automaticallyShowsCancelButton = false
        searchController.searchBar.text = self.latestQuery
    }
    
    private func configureTableView() {
        self.tableView.registerCellClass(SearchMovieTableViewCell.self)
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.prefetchDataSource = self
        self.tableView.rowHeight = 150
        self.tableView.separatorStyle = .singleLine
        self.tableView.separatorColor = CHColor.lightLabelBackground
        self.tableView.separatorInset = UIEdgeInsets.init(top: 0, left: 20, bottom: 0, right: 20)
        self.tableView.backgroundColor = .clear
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
    
    private func reset() {
        self.currentPage = 0
        self.isLastPage = false
        self.items = []
        Task {
            await MainActor.run {
                self.tableView.reloadData()
                if self.latestQuery == nil { self.contentAvailability = .beforeSearch }
            }
        }
    }
    
    private func callSearchAPI() {
        print(#function)
        self.contentAvailability = .available
//        guard let latestQuery, !latestQuery.isEmpty else { return }
//        let searchParams = SearchParameter(
//            query: latestQuery,
//            page: self.currentPage + 1,
//            offset: 20,
//            order: self.currentSort.rawValue,
//            color: self.selectedColorFilter?.filterName
//        )
//        NetworkManager().getSearchResult(
//            searchParameter: searchParams,
//            successHandler: { [weak self] response in
//                self?.handleResponse(response)
//            },
//            failureHandler: { [weak self] error in
//                self?.handleError(error)
//            }
//        )
    }
}

extension SearchResultViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        return self.items.count
    }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        guard
            let cell: SearchMovieTableViewCell = tableView.dequeueReusableCell(for: indexPath)
        else { return UITableViewCell() }
        let targetMovie = self.items[indexPath.row]
        let movieSummary = SearchMovieSummary(
            id: targetMovie.id,
            posterURL: targetMovie.posterURL,
            title: targetMovie.title,
            dateString: targetMovie.dateString,
            genres: targetMovie.genres,
            liked: findMovieIfLiked(movieID: targetMovie.id)
        )
        cell.configure(summary: targetMovie) { movieID in
            self.toggleLike(movieID: movieID)
        }
        return cell
    }
}

extension SearchResultViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let query = searchBar.text else { return }
        guard query != self.latestQuery else { return }
        self.latestQuery = query
        reset()
        callSearchAPI()
    }
}

extension SearchResultViewController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        guard !self.isLastPage else { return }
        let lineOffset = 3
        for indexPath in indexPaths {
            if indexPath.row == items.count - (lineOffset - 1) {
                callSearchAPI()
                break
            }
        }
    }
}


