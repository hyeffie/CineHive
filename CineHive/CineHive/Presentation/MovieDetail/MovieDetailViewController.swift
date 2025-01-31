//
//  MovieDetailViewController.swift
//  CineHive
//
//  Created by Effie on 1/31/25.
//

import UIKit

final class MovieDetailViewController: BaseViewController {
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
    
    private lazy var backdropCollectionView = UICollectionView(frame: .zero, collectionViewLayout: self.backdropCollectionViewLayout())
    
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
        let height = width * 0.75
        layout.itemSize = CGSize(width: width, height: height)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
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
            make.height.equalTo(self.view.frame.width * 0.75)
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
        tagStack.spacing = 2
        
        tagStack.addArrangedSubview(self.releaseDateTag)
        tagStack.addArrangedSubview(self.voteTag)
        tagStack.addArrangedSubview(self.genreTag)
        
        tagContainer.addSubview(tagStack)
        tagStack.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.verticalEdges.equalToSuperview()
            make.height.equalTo(20)
        }
        
        self.contentStack.addArrangedSubview(tagContainer)
        
        self.contentStack.addArrangedSubview(self.synopsisSection)
        self.synopsisSection.content.addSubview(self.synopsisLabel)
        self.synopsisLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(16)
            make.verticalEdges.equalToSuperview()
        }
        
        self.contentStack.addArrangedSubview(SpacingView(color: .blue))
        self.contentStack.addArrangedSubview(SpacingView(color: .red))
        
        configureBackdropCollectionView()
        configureBackdropPageConntrol()
    }
    
    private func configureDetail() {
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
        #warning("collection view 업데이트")
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
        #warning("collection view 업데이트")
    }
}

extension MovieDetailViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case self.backdropCollectionView:
            return self.backdropPaths.count
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
