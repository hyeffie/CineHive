//
//  SearchResultViewModel.swift
//  CineHive
//
//  Created by Effie on 2/12/25.
//

import Foundation

final class SearchResultViewModel: BaseViewModelProtocol {
    struct Input {
        let initialized: Observable<Void> = Observable(value: ())
        
        let viewDidAppear: Observable<Void> = Observable(value: ())
        
        let prefetchItemsAt: Observable<[Int]> = Observable(value: [])
        
        let searchButtonClickedWithQuery: Observable<String?> = Observable(value: nil)
        
        let addSummittedQuery: Observable<String?> = Observable(value: nil)
        
        let didSelectCellAtIndex: Observable<Int?> = Observable(value: nil)
        
        let likeButtonTappedForMovieID: Observable<Int?> = Observable(value: nil)
    }
    
    struct Output {
        let resultSummaries: Observable<[SearchMovieSummary]> = Observable(value: [])
        
        let goToDetail: Observable<MovieDetail?> = Observable(value: nil)
        
        let errorMessage: Observable<String?> = Observable(value: nil)
        
        let showKeyboard: Observable<Void> = Observable(value: ())
    }
    
    private struct Privates {
        let tmdbSummaries: Observable<[TMDBMovieSummary]> = Observable(value: [])
    }
    
    private(set) var input: Input
    
    private(set) var output: Output
    
    private var privates: Privates
    
    private let profileManager: UserProfileManager
    
    private let networkRequester: NetworkManager
    
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
    
    private var latestQuery: String?
    
    private var currentPage: Int = 0
    
    private var isLastPage: Bool = false
    
    init(
        query: String? = nil,
        profileManager: UserProfileManager,
        networkRequester: NetworkManager
    ) {
        self.input = Input()
        self.output = Output()
        self.privates = Privates()
        self.profileManager = profileManager
        self.networkRequester = networkRequester
        self.latestQuery = query
        transform()
    }
    
    func transform() {
        self.input.initialized.lazyBind { _ in
            self.callSearchAPI()
        }
        
        self.input.viewDidAppear.lazyBind { _ in
            if self.latestQuery == nil {
                self.output.showKeyboard.value = ()
            }
        }
        
        self.input.prefetchItemsAt.lazyBind { indices in
            self.prefetchItems(at: indices)
        }
        
        self.input.searchButtonClickedWithQuery.lazyBind { query in
            guard let query else { return }
            guard query != self.latestQuery else { return }
            self.profileManager.addSubmiitedQuery(query)
            self.latestQuery = query
            self.reset()
            self.callSearchAPI()
        }
        
        self.input.addSummittedQuery.lazyBind { query in
            guard let query else { return }
            self.profileManager.addSubmiitedQuery(query)
        }
        
        self.input.didSelectCellAtIndex.lazyBind { index in
            guard let index else { return }
            self.goToDetail(index: index)
        }
        
        self.input.likeButtonTappedForMovieID.lazyBind { movieID in
            guard let movieID else { return }
            self.profileManager.toggleLike(movieID: movieID)
        }
        
        self.privates.tmdbSummaries.lazyBind { _ in
            self.updateSearchResult()
        }
    }
    
    private func callSearchAPI() {
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
        self.privates.tmdbSummaries.value.append(contentsOf: response.results)
    }
    
    private func handleError(_ error: Error) {
        if let presentableError = error as? PresentableError {
            self.output.errorMessage.value = presentableError.message
        }
    }
    
    private func prefetchItems(at indices: [Int]) {
        guard self.isLastPage == false else { return }
        let lineOffset = 3
        for index in indices {
            if index == self.privates.tmdbSummaries.value.count - (lineOffset - 1) {
                callSearchAPI()
                break
            }
        }
    }
    
    private func reset() {
        self.currentPage = 0
        self.isLastPage = false
        self.privates.tmdbSummaries.value = []
    }
    
    private func updateSearchResult() {
        let searchSummaries = self.privates.tmdbSummaries.value.map { self.mapMovieSummary($0) }
        self.output.resultSummaries.value = searchSummaries
    }
    
    private func mapMovieSummary(_ movieSummary: TMDBMovieSummary) -> SearchMovieSummary {
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
        
        let liked = self.profileManager.findMovieIfLiked(movieID: movieSummary.id) ?? false
        
        return SearchMovieSummary(
            id: movieSummary.id,
            posterURL: TMDBImage.w500(movieSummary.posterPath ?? "").url,
            title: movieSummary.title,
            dateString: dateString,
            genres: genres,
            liked: liked
        )
    }
    
    private func goToDetail(index: Int) {
        let summary = self.privates.tmdbSummaries.value[index]
        let liked = self.profileManager.findMovieIfLiked(movieID: summary.id) ?? false
        let detail = MovieDetail(
            id: summary.id,
            title: summary.title,
            releaseDate: summary.releaseDate,
            voteAverage: summary.voteAverage,
            genreIDS: summary.genreIDS ?? [],
            overview: summary.overview,
            liked: liked
        )
        self.output.goToDetail.value = detail
    }
}
