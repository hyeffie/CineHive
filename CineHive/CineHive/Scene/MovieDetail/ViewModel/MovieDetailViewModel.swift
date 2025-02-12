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
        
        let synopsisFoldToggleButtonTapped: Observable<Void> = Observable(value: ())
    }
    
    struct Output {
        let navigationTitle: Observable<String?> = Observable(value: nil)
        
        let movieIsLiked: Observable<Bool> = Observable(value: false)
        
        let releaseDate: Observable<String?> = Observable(value: nil)
        
        let voteAveraget: Observable<String?> = Observable(value: nil)
        
        let genresText: Observable<String?> = Observable(value: nil)
        
        let synopsis: Observable<String?> = Observable(value: nil)
        
        let backdropURLs: Observable<[URL]> = Observable(value: [])
        
        let castInfos: Observable<[CastInfo]> = Observable(value: [])
        
        let posterURLs: Observable<[URL]> = Observable(value: [])
        
        let currentPage: Observable<Int> = Observable(value: 0)
        
        let errorMessage: Observable<String?> = Observable(value: nil)
        
        let synopSectionButtonTitle: Observable<String> = Observable(value: "More")
        
        let synopLabelNumberOfLines: Observable<Int> = Observable(value: 0)
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
        
        self.input.synopsisFoldToggleButtonTapped.lazyBind { _ in
            let futureState = self.privates.synopSectionFoldedState.value == .folded ? SynopSectionFoldedState.unfolded : .folded
            self.output.synopSectionButtonTitle.value = futureState.buttonTitle
            self.output.synopLabelNumberOfLines.value = futureState.numberOfLines
        }
    }
    
    private func getDetail() {
        self.output.navigationTitle.value = self.movieDetail.title
        self.output.releaseDate.value = self.movieDetail.releaseDate
        self.output.voteAveraget.value = String(describing: self.movieDetail.voteAverage)
        let genres = self.movieDetail.genreIDS.compactMap { MovieGenre.getName(by:$0) }.prefix(2)
        let genreString = Array(genres).joined(separator: ", ")
        self.output.genresText.value = genreString
        self.output.synopsis.value = self.movieDetail.overview
        self.output.movieIsLiked.value = self.movieDetail.liked
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
