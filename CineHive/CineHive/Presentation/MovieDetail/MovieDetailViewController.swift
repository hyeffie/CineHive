//
//  MovieDetailViewController.swift
//  CineHive
//
//  Created by Effie on 1/31/25.
//

import UIKit

final class MovieDetailViewController: BaseViewController {
    @UserDefault(key: UserDefaultKey.userProfile)
    private var userProfile: ProfileInfo!
    
    private let networkRequester = NetworkManager()
    
    private let movieDetail: MovieDetail
    
    private var backdropPaths: [String]
    
    private var casts: [MovieCastResponse.Cast]
    
    private var posterPaths: [String]
    
    private let scrollView = UIScrollView()
    
    private let contentStack = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .fill
        stack.spacing = 12
        return stack
    }()
    
    private lazy var backdropCollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: self.backdropCollectionViewLayout()
    )
    
    private let backdropPageControl = UIPageControl(frame: .zero)
    
    private lazy var releaseDateTag = InfoTagView(symbol: .calendar)
    
    private lazy var voteTag = InfoTagView(symbol: .star)
    
    private lazy var genreTag = InfoTagView(symbol: .film)
    
    private let synopsisLabel = BaseLabel(font: CHFont.medium, numberOfLines: 3)
    
    private lazy var synopsisSection = SectionedView(
        title: "Synopsis",
        accessoryButtonInfo: ("More", { button in self.toggleFoldingSynopsis(button: button)  }),
        content: UIView()
    )
    
    private lazy var castCollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: self.castCollectionViewLayout()
    )
    
    private lazy var castSection = SectionedView(
        title: "Cast",
        content: self.castCollectionView
    )
    
    private lazy var posterCollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: self.posterCollectionViewLayout()
    )
    
    private lazy var posterSection = SectionedView(
        title: "Poster",
        content: self.posterCollectionView
    )
    
    init(movieDetail: MovieDetail) {
        self.movieDetail = movieDetail
        self.backdropPaths = []
        self.casts = []
        self.posterPaths = []
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureDetail()
        getImages()
        getCast()
        configureViews()
    }
    
    private func backdropCollectionViewLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        let width = self.view.frame.width
        let height = width * 0.6
        layout.itemSize = CGSize(width: width, height: height)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        return layout
    }
    
    private func castCollectionViewLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        let width = self.view.frame.width * 0.4
        let height = width * 0.35
        layout.itemSize = CGSize(width: width, height: height)
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        return layout
    }
    
    private func posterCollectionViewLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        let width = self.view.frame.width * 0.27
        let height = width * 1.3
        layout.itemSize = CGSize(width: width, height: height)
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        return layout
    }
    
    private func configureViews() {
        self.view.backgroundColor = .mainBackground
        
        self.view.addSubview(self.scrollView)
        self.scrollView.snp.makeConstraints { make in
            make.edges.equalTo(self.view.safeAreaLayoutGuide)
            make.width.equalTo(self.view.safeAreaLayoutGuide)
        }
        
        self.scrollView.addSubview(self.contentStack)
        self.contentStack.snp.makeConstraints { make in
            make.edges.width.equalTo(self.scrollView)
        }
        
        let backdropContainer = UIView()
        
        backdropContainer.addSubview(self.backdropCollectionView)
        self.backdropCollectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalTo(self.view.frame.width * 0.6)
        }
        
        backdropContainer.addSubview(self.backdropPageControl)
        self.backdropPageControl.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(16)
        }
        
        self.contentStack.addArrangedSubview(backdropContainer)
        
        let tagContainer = UIView()
        
        let tagStack = UIStackView()
        tagStack.axis = .horizontal
        tagStack.backgroundColor = .darkLabelBackground
        tagStack.alignment = .center
        tagStack.spacing = 1
        
        tagStack.addArrangedSubview(self.releaseDateTag)
        tagStack.addArrangedSubview(self.voteTag)
        tagStack.addArrangedSubview(self.genreTag)
        
        tagContainer.addSubview(tagStack)
        tagStack.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.verticalEdges.equalToSuperview()
        }
        
        self.contentStack.addArrangedSubview(tagContainer)
        
        self.contentStack.addArrangedSubview(self.synopsisSection)
        self.synopsisSection.content.addSubview(self.synopsisLabel)
        self.synopsisLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(16)
            make.verticalEdges.equalToSuperview()
        }
        
        self.contentStack.addArrangedSubview(self.castSection)
        self.castSection.content.snp.makeConstraints { make in
            make.height.equalTo(150)
        }
        
        self.contentStack.addArrangedSubview(self.posterSection)
        self.posterSection.content.snp.makeConstraints { make in
            make.height.equalTo(150)
        }
        
        self.navigationItem.rightBarButtonItem = LikeBarButtonItem(
            id: self.movieDetail.id,
            liked: self.movieDetail.liked,
            action: { [weak self] _ in self?.toggleLike() }
        )
        
        configureBackdropCollectionView()
        configureBackdropPageConntrol()
        configureCastCollectionView()
        configurePosterCollectionView()
    }
    
    private func configureDetail() {
        self.title = self.movieDetail.title
        if let releaseDate = self.movieDetail.releaseDate { self.releaseDateTag.configure(with: releaseDate) }
        if let voteAverage = self.movieDetail.voteAverage { self.voteTag.configure(with: "\(voteAverage)") }
        let genres = self.movieDetail.genreIDS.compactMap { MovieGenre.getName(by:$0) }.prefix(2)
        let genreString = Array(genres).joined(separator: ", ")
        self.genreTag.configure(with: genreString)
        self.synopsisLabel.text = self.movieDetail.overview
    }
    
    private func configureBackdropCollectionView() {
        self.backdropCollectionView.registerCellClass(BackdropCollectionViewCell.self)
        self.backdropCollectionView.dataSource = self
        self.backdropCollectionView.delegate = self
        
        self.backdropCollectionView.isPagingEnabled = true
    }
    
    private func configureBackdropPageConntrol() {
        self.backdropPageControl.numberOfPages = self.backdropPaths.count
        self.backdropPageControl.allowsContinuousInteraction = true
        self.backdropPageControl.backgroundStyle = .prominent
        
        let valueChangeAction = UIAction { [weak self] action in
            guard let control = action.sender as? UIPageControl else {
                return
            }
            self?.moveBackdropPage(to: control.currentPage)
        }
        self.backdropPageControl.addAction(valueChangeAction, for: .valueChanged)
    }
    
    private func reconfigureBackdropPageConntrol() {
        self.backdropPageControl.numberOfPages = self.backdropPaths.count
        self.backdropPageControl.currentPage = 0
    }
    
    @objc private func moveBackdropPage(to page: Int) {
        self.backdropCollectionView.scrollToItem(at: IndexPath(row: page, section: 0), at: .centeredHorizontally, animated: true)
    }
    
    private func toggleFoldingSynopsis(button: UIButton) {
        if self.synopsisLabel.numberOfLines == 0 {
            self.synopsisLabel.numberOfLines = 3
            button.setTitle("More", for: .normal)
        } else {
            self.synopsisLabel.numberOfLines = 0
            button.setTitle("Hide", for: .normal)
        }
    }
    
    private func configureCastCollectionView() {
        self.castCollectionView.registerCellClass(CastCollectionViewCell.self)
        self.castCollectionView.dataSource = self
        self.castCollectionView.delegate = self
        self.castCollectionView.backgroundColor = .clear
    }
    
    private func configurePosterCollectionView() {
        self.posterCollectionView.registerCellClass(PosterCollectionViewCell.self)
        self.posterCollectionView.dataSource = self
        self.posterCollectionView.delegate = self
        self.posterCollectionView.backgroundColor = .clear
    }
}

extension MovieDetailViewController {
    private func getCast() {
        self.networkRequester.getMovieCast(
            movieID: self.movieDetail.id,
            movieCastParameter: .init(),
            successHandler: { [weak self] response in
                self?.handleCastResponse(response: response)
            },
            failureHandler: { [weak self] networkError in
                self?.handleError(networkError)
            }
        )
    }
    
    private func handleCastResponse(response: MovieCastResponse) {
        self.casts = response.cast
        self.castCollectionView.reloadData()
    }
    
    private func handleError(_ error: Error) {
        if let presentableError = error as? PresentableError {
            presentErrorAlert(message: presentableError.message)
        }
    }
    
    private func getImages() {
        self.networkRequester.getMovieImages(
            movieID: self.movieDetail.id,
            movieImageParameter: .init(),
            successHandler: { [weak self] response in
                self?.handleImageResponse(response: response)
            },
            failureHandler: { [weak self] networkError in
                self?.handleError(networkError)
            }
        )
    }
    
    private func handleImageResponse(response: MovieImageResponse) {
        self.backdropPaths = Array(response.backdrops.compactMap(\.filePath).prefix(5))
        self.backdropCollectionView.reloadData()
        reconfigureBackdropPageConntrol()
        
        self.posterPaths = response.posters.compactMap(\.filePath)
        self.posterCollectionView.reloadData()
    }
}

extension MovieDetailViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case self.backdropCollectionView:
            return self.backdropPaths.count
        case self.castCollectionView:
            return self.casts.count
        case self.posterCollectionView:
            return self.posterPaths.count
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
        case self.backdropCollectionView:
            guard let cell: BackdropCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath) else { return UICollectionViewCell() }
            let path = self.backdropPaths[indexPath.item]
            let url = TMDBImage.original(path).url
            cell.configure(with: url)
            return cell
        case self.castCollectionView:
            guard let cell: CastCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath) else { return UICollectionViewCell() }
            let targetCast = self.casts[indexPath.item]
            let profileURL = TMDBImage.w500(targetCast.profilePath ?? "").url
            let castInfo = CastInfo(profileURL: profileURL, name: targetCast.name, character: targetCast.character)
            cell.configure(with: castInfo)
            return cell
        case self.posterCollectionView:
            guard let cell: PosterCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath) else { return UICollectionViewCell() }
            let path = self.posterPaths[indexPath.item]
            let posterURL = TMDBImage.w500(path).url
            cell.configure(with: posterURL)
            return cell
        default:
            return UICollectionViewCell()
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView === self.backdropCollectionView else { return }
        let pageWidth = backdropCollectionView.bounds.width
        let currentPage = Int((scrollView.contentOffset.x + (0.5 * pageWidth)) / pageWidth)
        backdropPageControl.currentPage = currentPage
    }
}

extension MovieDetailViewController {
    private func toggleLike() {
        let movieID = self.movieDetail.id
        if self.userProfile.likedMovieIDs.contains(movieID) {
            self.userProfile.likedMovieIDs.removeAll { id in id == movieID }
        } else {
            self.userProfile.likedMovieIDs.append(movieID)
        }
        notifyLikedMovieMutated()
    }
    
    private func notifyLikedMovieMutated() {
        NotificationCenter.default.post(name: CHNotification.userLikedMovieMutated, object: nil)
    }
}
