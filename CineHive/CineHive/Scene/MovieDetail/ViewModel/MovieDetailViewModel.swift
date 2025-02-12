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
        
        let likeButtonTapped: Observable<Void> = Observable(value: ())
        
        let scrollViewDidScroll: Observable<(pageWidth: CGFloat, offset: CGFloat)?> = Observable(value: nil)
        
        let backdropPageControlValueChanged: Observable<Int> = Observable(value: 0)
        
        let synopsisFoldToggleButtonTapped: Observable<Void> = Observable(value: ())
    }
    
    struct Output {
        let detail: Observable<MovieDetailPresentationInfo?> = Observable(value: nil)
        
        let backdropURLs: Observable<[URL?]> = Observable(value: [])
        
        let castInfos: Observable<[CastInfo]> = Observable(value: [])
        
        let posterURLs: Observable<[URL?]> = Observable(value: [])
        
        let currentPage: Observable<Int> = Observable(value: 0)
        
        let errorMessage: Observable<String?> = Observable(value: nil)
        
        let synopSectionChanged: Observable<(String, Int)> = Observable(value: ("More", 0))
        
        let backdropCollectionViewScrollToItem: Observable<Int?> = Observable(value: nil)
    }
    
    private struct Privates {
        let imageResponse: Observable<MovieImageResponse?> = Observable(value: nil)
        
        let castResponse: Observable<MovieCastResponse?> = Observable(value: nil)
        
        let synopSectionFoldedState: Observable<SynopSectionFoldedState> = Observable(value: .folded)
    }
    
    private(set) var input: Input
    
    private(set) var output: Output
    
    private var privates: Privates
    
    private let profileManager: UserProfileManager
    
    private let networkRequester: NetworkManager
    
    private let movieDetail: MovieDetail
    
    init(
        movieDetail: MovieDetail,
        profileManager: UserProfileManager,
        networkRequester: NetworkManager
    ) {
        self.movieDetail = movieDetail
        self.input = Input()
        self.output = Output()
        self.privates = Privates()
        self.profileManager = profileManager
        self.networkRequester = networkRequester
        
        transform()
    }
    
    enum SynopSectionFoldedState {
        case folded
        case unfolded
        
        var buttonTitle: String {
            switch self {
            case .folded: return "More"
            case .unfolded: return "Hide"
            }
        }
        
        var numberOfLines: Int {
            switch self {
            case .folded: return 3
            case .unfolded: return 0
            }
        }
    }
    
    func transform() {
        self.input.initialized.lazyBind { _ in
            self.getDetail()
            self.getImages()
            self.getCast()
        }
        
        self.input.likeButtonTapped.lazyBind { _ in
            self.profileManager.toggleLike(movieID: self.movieDetail.id)
        }
        
        self.input.scrollViewDidScroll.lazyBind { (info: (pageWidth: CGFloat, offset: CGFloat)?) in
            guard let info else { return }
            let currentPage = Int((info.offset + (0.5 * info.pageWidth)) / info.pageWidth)
            self.output.currentPage.value = currentPage
        }
        
        self.input.backdropPageControlValueChanged.lazyBind { futurePage in
            self.output.backdropCollectionViewScrollToItem.value = futurePage
        }
        
        self.input.synopsisFoldToggleButtonTapped.lazyBind { _ in
            let futureState = self.privates.synopSectionFoldedState.value == .folded ? SynopSectionFoldedState.unfolded : .folded
            self.privates.synopSectionFoldedState.value = futureState
        }
        
        transformPrivates()
    }
    
    private func transformPrivates() {
        self.privates.imageResponse.lazyBind { response in
            guard let response else { return }
            self.output.backdropURLs.value = response.backdrops.compactMap(\.filePath).prefix(5).map { TMDBImage.original($0).url }
            self.output.posterURLs.value = response.posters.compactMap(\.filePath).map { TMDBImage.w500($0).url }
        }
        
        self.privates.castResponse.lazyBind { response in
            guard let response else { return }
            self.output.castInfos.value = response.cast.map { cast in
                let profileURL = TMDBImage.w500(cast.profilePath ?? "").url
                return CastInfo(profileURL: profileURL, name: cast.name, character: cast.character)
            }
        }

        self.privates.synopSectionFoldedState.bind { futureState in
            self.output.synopSectionChanged.value = (futureState.buttonTitle, futureState.numberOfLines)
        }
    }
    
    private func getDetail() {
        let detail = self.movieDetail
        let genres = detail.genreIDS.compactMap { MovieGenre.getName(by:$0) }.prefix(2)
        let genreString = Array(genres).joined(separator: ", ")
        
        let result =  MovieDetailPresentationInfo(
            navigationTitle: detail.title,
            movieID: detail.id,
            movieIsLiked: detail.liked,
            releaseDate: detail.releaseDate,
            voteAverage: String(describing: detail.voteAverage),
            genresText: genreString,
            synopsis: detail.overview
        )
        self.output.detail.value = result
    }
    
    private func getImages() {
        self.networkRequester.getMovieImages(
            movieID: self.movieDetail.id,
            movieImageParameter: .init(),
            successHandler: { [weak self] response in
                self?.privates.imageResponse.value = response
            },
            failureHandler: { [weak self] networkError in
                self?.handleError(networkError)
            }
        )
    }
    
    private func getCast() {
        self.networkRequester.getMovieCast(
            movieID: self.movieDetail.id,
            movieCastParameter: .init(),
            successHandler: { [weak self] response in
                self?.privates.castResponse.value = response
            },
            failureHandler: { [weak self] networkError in
                self?.handleError(networkError)
            }
        )
    }
    
    private func handleError(_ error: Error) {
        if let presentableError = error as? PresentableError {
            self.output.errorMessage.value = presentableError.message
        }
    }
}

struct MovieDetailPresentationInfo {
    let navigationTitle: String
    let movieID: Int
    let movieIsLiked: Bool
    let releaseDate: String?
    let voteAverage: String
    let genresText: String
    let synopsis: String?
}
