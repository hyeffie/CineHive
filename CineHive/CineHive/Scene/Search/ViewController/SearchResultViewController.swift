//
//  SearchResultViewController.swift
//  CineHive
//
//  Created by Effie on 1/31/25.
//

import UIKit

final class SearchResultViewController: BaseViewController {
    private enum ContentState: ContenUnavailableState {
        case noResult
        
        var displayingMessage: String {
            switch self {
            case .noResult: return "원하는 검색 결과를 찾지 못했습니다"
            }
        }
    }
    
    @UserDefault(key: UserDefaultKey.userProfile)
    private var userProfile: ProfileInfo!
    
    private let networkRequester = NetworkManager()
    
    private var items: [MovieSummary]
    
    private var latestQuery: String?
    
    private var currentPage: Int
    
    private var isLastPage: Bool
    
    private let dateDecoder = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd" // 2020-04-09
        return formatter
    }()
    
    private let dateEncoder = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy. MM. dd" // 2020. 04. 09
        return formatter
    }()
    
    private let searchController = UISearchController(searchResultsController: nil)
    
    private let tableView = UITableView(frame: .zero)
    
    init(query: String? = nil) {
        self.items = []
        self.latestQuery = query
        self.currentPage = 0
        self.isLastPage = false
        super.init(nibName: nil, bundle: nil)
        callSearchAPI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if self.latestQuery == nil {
            DispatchQueue.main.async { [weak self] in
                self?.searchController.searchBar.becomeFirstResponder()
            }
        }
    }
}

extension SearchResultViewController {
    private func configureViews() {
        self.navigationItem.title = "영화 검색"
        
        self.view.addSubview(self.tableView)
        self.tableView.snp.makeConstraints { make in
            make.edges.equalTo(self.view.safeAreaLayoutGuide)
        }
        
        configureSearchController()
        configureTableView()
    }
    
    private func configureSearchController() {
        self.searchController.searchBar.delegate = self
        self.searchController.hidesNavigationBarDuringPresentation = false
        self.searchController.searchBar.placeholder = "영화를 검색해보세요."
        self.searchController.searchBar.searchTextField.clearButtonMode = .never
        self.searchController.automaticallyShowsCancelButton = false
        self.searchController.searchBar.text = self.latestQuery
        navigationItem.searchController = self.searchController
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
}

extension SearchResultViewController {
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
                if self.latestQuery == nil { self.contentIsAvailable = .available }
            }
        }
    }
}

extension SearchResultViewController {
    private func callSearchAPI() {
        self.contentIsAvailable = .available
        guard let latestQuery, !latestQuery.isEmpty else { return }
        let searchParams = SearchMovieRequestParameter(
            query: latestQuery,
            page: self.currentPage + 1
        )
        
        self.networkRequester.getSearchResult(
            searchMovieParameter: searchParams,
            successHandler: { [weak self] response in
                self?.handleResponse(response)
            },
            failureHandler: { [weak self] error in
                self?.handleError(error)
            }
        )
    }
    
    private func handleResponse(_ response: SearchMovieResponse) {
        if !response.results.isEmpty { self.currentPage += 1 }
        self.isLastPage = self.currentPage == response.totalPages
        self.items.append(contentsOf: response.results)
        Task {
            await MainActor.run {
                self.tableView.reloadData()
                self.contentIsAvailable = self.items.isEmpty ? .unavailable(ContentState.noResult) : .available
            }
        }
    }
    
    private func handleError(_ error: Error) {
        if let presentableError = error as? PresentableError {
            presentErrorAlert(message: presentableError.message)
        }
    }
    
    private func goToDetail(summary: MovieSummary) {
        let detail = MovieDetail(
            id: summary.id,
            title: summary.title,
            releaseDate: summary.releaseDate,
            voteAverage: summary.voteAverage,
            genreIDS: summary.genreIDS ?? [],
            overview: summary.overview,
            liked: findMovieIfLiked(movieID: summary.id)
        )
        
        let viewController = MovieDetailViewController(movieDetail: detail)
        self.push(viewController)
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
        let searchSummary = convertMovieSummaryToSearchSummary(targetMovie)
        cell.configure(summary: searchSummary) { movieID in self.toggleLike(movieID: movieID) }
        return cell
    }
    
    private func convertMovieSummaryToSearchSummary(_ movieSummary: MovieSummary) -> SearchMovieSummary {
        let dateString: String
        if let releaseDate = movieSummary.releaseDate,
            let date = self.dateDecoder.date(from: releaseDate) {
            dateString = self.dateEncoder.string(from: date)
        } else {
            dateString = ""
        }
        
        var genres: [String] = []
        if let genreIDS = movieSummary.genreIDS {
            genres.append(contentsOf: Array(genreIDS.compactMap { id in MovieGenre.getName(by: id) }.prefix(2)))
        }
        
        return SearchMovieSummary(
            id: movieSummary.id,
            posterURL: TMDBImage.w500(movieSummary.posterPath ?? "").url,
            title: movieSummary.title,
            dateString: dateString,
            genres: genres,
            liked: findMovieIfLiked(movieID: movieSummary.id)
        )
    }
    
    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        tableView.deselectRow(at: indexPath, animated: true)
        let targetSummary = self.items[indexPath.row]
        goToDetail(summary: targetSummary)
    }
}

extension SearchResultViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let query = searchBar.text else { return }
        guard query != self.latestQuery else { return }
        addSubmiitedQuery(query)
        self.latestQuery = query
        reset()
        callSearchAPI()
    }
    
    private func addSubmiitedQuery(_ query: String) {
        guard !query.isEmpty else { return }
        let newSubmission = SubmittedQuery(submittedDate: .now, query: query)
        self.userProfile.submittedQueries.update(with: newSubmission)
        notifyNewSubmission()
        print(self.userProfile.submittedQueries.count)
        print(self.userProfile.submittedQueries.sorted(by: { $0.submittedDate < $1.submittedDate }))
    }
    
    private func notifyNewSubmission() {
        NotificationCenter.default.post(name: CHNotification.userSubmittedQueryMutated, object: nil)
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
