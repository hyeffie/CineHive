//
//  MovieDetailViewModel.swift
//  CineHive
//
//  Created by Effie on 2/12/25.
//

import Foundation

final class MovieDetailViewModel: BaseViewModelProtocol {
    struct Input {
        let initialized: Observable<Void> = Observable(value: ())
        
        let viewDidLoad: Observable<Void> = Observable(value: ())
        
        let likeButtonTapped: Observable<Void> = Observable(value: ())
        
        let scrollViewDidScroll: Observable<(pageWidth: CGFloat, horizontalOffset: CGFloat)?> = Observable(value: nil)
        
        let synopsisFoldToggleButtonTapped: Observable<Void> = Observable(value: ())
    }
    
    struct Output {
        let movieDetail: MovieDetail
        
        let backdropURLs: Observable<[URL]> = Observable(value: [])
        
        let castInfos: Observable<[CastInfo]> = Observable(value: [])
        
        let posterURLs: Observable<[URL]> = Observable(value: [])
        
        let currentPage: Observable<Int> = Observable(value: 0)
    }
    
    private struct Privates {
        
    }
    
    private(set) var input: Input
    
    private(set) var output: Output
    
    private var privates: Privates
    
    private let profileManager: UserProfileManager
    
    private let networkRequester: NetworkManager
    
    init(
        movieDetail: MovieDetail,
        profileManager: UserProfileManager,
        networkRequester: NetworkManager
    ) {
        self.input = Input()
        self.output = Output(movieDetail: movieDetail)
        self.privates = Privates()
        self.profileManager = profileManager
        self.networkRequester = networkRequester
        
        transform()
    }
    
    func transform() {
        
    }
}
