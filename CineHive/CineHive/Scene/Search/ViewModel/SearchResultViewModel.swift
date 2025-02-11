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
        
        let viewDidLoad: Observable<Void> = Observable(value: ())
        
        let viewDidAppear: Observable<Void> = Observable(value: ())
        
        let backToMainButtonTapped: Observable<Void> = Observable(value: ())
        
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
    }
    
    private struct Privates {
        let tmdbSummaries: Observable<[TMDBMovieSummary]> = Observable(value: [])
        
        var latestQuery: String?
        
        var currentPage: Int = 0
        
        var isLastPage: Bool = false
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
    
    init(
        query: String? = nil,
        profileManager: UserProfileManager,
        networkRequester: NetworkManager
    ) {
        self.input = Input()
        self.output = Output()
        self.privates = Privates(latestQuery: query)
        self.profileManager = profileManager
        self.networkRequester = networkRequester
    }
    
    func transform() {
        
    }
}
