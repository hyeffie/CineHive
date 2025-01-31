//
//  MovieDetailViewController.swift
//  CineHive
//
//  Created by Effie on 1/31/25.
//

import UIKit

final class MovieDetailViewController: BaseViewController {
    
    private let movieDetail: MovieDetail
    
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
    
    private let synopsisSection = SectionedView(
        title: "Synopsis",
        accessoryButtonInfo: ("More", { }),
        content: BaseLabel(font: CHFont.medium)
    )
    
    init(movieDetail: MovieDetail) {
        self.movieDetail = movieDetail
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureDetail()
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
        
        self.contentStack.addArrangedSubview(SpacingView(color: .blue))
        self.contentStack.addArrangedSubview(tagContainer)
        self.contentStack.addArrangedSubview(SpacingView(color: .red))
        
        configureBackdropCollectionView()
        configureBackdropPageConntrol()
    }
    
    private func configureDetail() {
        if let releaseDate = self.movieDetail.releaseDate { self.releaseDateTag.configure(with: releaseDate) }
        if let voteAverage = self.movieDetail.voteAverage { self.voteTag.configure(with: "\(voteAverage)") }
    }
    
    private func configureBackdropCollectionView() {
        self.backdropCollectionView.registerCellClass(BackdropCollectionViewCell.self)
        self.backdropCollectionView.dataSource = self
        self.backdropCollectionView.delegate = self
        
        self.backdropCollectionView.isPagingEnabled = true
    }
    
    private func configureBackdropPageConntrol() {
        self.backdropPageControl.numberOfPages = Self.pool.count
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
    
    @objc private func moveBackdropPage(to page: Int) {
        self.backdropCollectionView.scrollToItem(at: IndexPath(row: page, section: 0), at: .centeredHorizontally, animated: true)
    }
}

extension MovieDetailViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    static let pool: [URL?] = [
        .init(string: "https://image.cine21.com/resize/cine21/still/2019/0621/52641_5d0c78937941d[S700,700].jpg"),
        
            .init(string: "https://image.cine21.com/resize/cine21/still/2019/0621/52641_5d0c789398ab3[S700,700].jpg"),
        
            .init(string: "https://image.cine21.com/resize/cine21/still/2019/0621/52641_5d0c7893ca9ef[S700,700].jpg"),
        
            .init(string: "https://image.cine21.com/resize/cine21/still/2019/0523/52641_5ce62e7810d5e[S700,700].jpg"),
        
            .init(string: "https://image.cine21.com/resize/cine21/still/2019/0523/52641_5ce62e7885a0d[S700,700].jpg"),
    ]
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Self.pool.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
        case self.backdropCollectionView:
            guard let cell: BackdropCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath) else { return UICollectionViewCell() }
            cell.configure(with: Self.pool[indexPath.item])
            return cell
        default:
            return UICollectionViewCell()
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageWidth = backdropCollectionView.bounds.width
        let currentPage = Int((scrollView.contentOffset.x + (0.5 * pageWidth)) / pageWidth)
        backdropPageControl.currentPage = currentPage
    }
}

#Preview {
    let detail = MovieDetail.init(id: 12, title: "하얼빈", releaseDate: "2025-01-01", voteAverage: 4.5, genreIDS: [28, 16, 80],
                 overview: "Alamofire builds on Linux, Windows, and Android but there are missing features and many issues in the underlying swift-corelibs-foundation that prevent full functionality and may cause crashes. These include:",
                 liked: true)
    
    return MovieDetailViewController(movieDetail: detail)
}

final class SpacingView: UIView {
    init(color: UIColor = .red) {
        super.init(frame: .zero)
        self.backgroundColor = color
        configure()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        self.snp.makeConstraints { make in
            make.height.equalTo(500)
        }
    }
}

final class BackdropCollectionViewCell: UICollectionViewCell {
    private let imageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = CHColor.darkLabelBackground
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureViews()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureViews() {
        self.contentView.addSubview(self.imageView)
        self.imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func configure(with imageURL: URL?) {
        self.imageView.kf.setImage(with: imageURL)
    }
}

extension BackdropCollectionViewCell: ReusableCell {}
