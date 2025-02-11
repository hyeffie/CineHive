//
//  MainViewModel.swift
//  CineHive
//
//  Created by Effie on 2/11/25.
//

import Foundation

final class MainViewModel: BaseViewModelProtocol {
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
    
    struct Input {
        let initialized: Observable<Void> = Observable(value: ())
        
        let likeButtonTappedForMovieID: Observable<Int?> = Observable(value: nil)
        
        let didSelectCellAtIndex: Observable<Int?> = Observable(value: nil)
        
        let searchButtonTapped: Observable<Void> = Observable(value: ())
        
        let deleteAllQueriesButtonTapped: Observable<Void> = Observable(value: ())
        
        let deleteQueryButtonTapped: Observable<String?> = Observable(value: nil)
        
        let queryButtonTapped: Observable<String?> = Observable(value: nil)
        
        let profileViewTapped: Observable<Void> = Observable(value: ())
    }
    
    struct Output {
        let sumittedQuries: Observable<[SubmittedQuery]> = Observable(value: [])
        
        let trendingMovieSummaries: Observable<[FeaturedMovieSummary]> = Observable(value: [])
        
        let goToProfileEdit: Observable<Void> = Observable(value: ())
        
        let goToSearch: Observable<String?> = Observable(value: nil)
        
        let goToDetail: Observable<MovieDetail?> = Observable(value: nil)
        
        let errorMessage: Observable<String?> = Observable(value: nil)
    }
    
    private struct Privates {
        let trendingMovies: Observable<[TMDBMovieSummary]> = Observable(value: [])
    }
    
    private(set) var input: Input
    
    private(set) var output: Output
    
    private var privates: Privates
    
    private let profileManager: UserProfileManager
    
    private let networkRequester: NetworkManager
    
    init(
        profileManager: UserProfileManager,
        networkRequester: NetworkManager
    ) {
        self.input = Input()
        self.output = Output()
        self.privates = Privates()
        self.profileManager = profileManager
        self.networkRequester = networkRequester
        
        addNotificationObserver()
        transform()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func transform() {
        self.input.initialized.bind { _ in
            self.fetchRecentQuery()
            self.getTrendingMovies()
        }
        
        self.input.likeButtonTappedForMovieID.lazyBind { movieID in
            guard let movieID else { return }
            self.profileManager.toggleLike(movieID: movieID)
        }
        
        self.input.didSelectCellAtIndex.lazyBind { cellIndex in
            guard let cellIndex else { return }
            let summary = self.privates.trendingMovies.value[cellIndex]
            
            let detail = MovieDetail(
                id: summary.id,
                title: summary.title,
                releaseDate: summary.releaseDate,
                voteAverage: summary.voteAverage,
                genreIDS: summary.genreIDS ?? [],
                overview: summary.overview,
                liked: self.profileManager.findMovieIfLiked(movieID: summary.id) ?? false
            )
            
            self.output.goToDetail.value = detail
        }
        
        self.input.searchButtonTapped.lazyBind { _ in
            self.output.goToSearch.value = nil
        }
        
        self.input.deleteAllQueriesButtonTapped.lazyBind { _ in
            self.profileManager.deleteAllSubmittedQueries()
        }
        
        self.input.deleteQueryButtonTapped.lazyBind { query in
            guard let query else { return }
            self.profileManager.deleteSubmittedQuery(query)
        }
        
        self.input.queryButtonTapped.lazyBind { query in
            guard let query else { return }
            self.output.goToSearch.value = query
        }
        
        self.input.profileViewTapped.lazyBind { _ in
            self.output.goToProfileEdit.value = ()
        }
        
        self.privates.trendingMovies.lazyBind { tmdbSummaries in
            self.updateTrendingMovie()
        }
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
        updateTrendingMovie()
    }
    
    @objc private func updateRecentQuerys() {
        fetchRecentQuery()
    }
    
    private func fetchRecentQuery() {
        let queries = self.profileManager.getProfileInfo()?.submittedQueries ?? .init()
        let sortedQueries = queries.sorted { $0.submittedDate > $1.submittedDate }
        self.output.sumittedQuries.value = sortedQueries
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
        self.privates.trendingMovies.value = response.movies
    }
    
    private func handleError(_ error: Error) {
        if let presentableError = error as? PresentableError {
            self.output.errorMessage.value = presentableError.message
        }
    }
    
    private func updateTrendingMovie() {
        let summaries = self.privates.trendingMovies.value.map { target in
            let liked = self.profileManager.findMovieIfLiked(movieID: target.id) ?? false
            return FeaturedMovieSummary(
                id: target.id,
                posterImageURL: TMDBImage.w500(target.posterPath ?? "").url,
                title: target.title,
                synopsys: target.overview ?? "",
                liked: liked
            )
        }
        self.output.trendingMovieSummaries.value = summaries
    }
}
