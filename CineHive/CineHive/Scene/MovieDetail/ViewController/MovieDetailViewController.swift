//
//  MovieDetailViewController.swift
//  CineHive
//
//  Created by Effie on 1/31/25.
//

import UIKit

final class MovieDetailViewController: BaseViewController {
    private let viewModel: MovieDetailViewModel
    
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
    
    private let synopsisContainer = UIView()
    
    private let synopsisSection = SectionView()
    
    private lazy var castCollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: self.castCollectionViewLayout()
    )
    
    private let castSection = SectionView(contentHeight: 130)
    
    private lazy var posterCollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: self.posterCollectionViewLayout()
    )
    
    private let posterSection = SectionView(contentHeight: 150)
    
    init(viewModel: MovieDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        bind()
        self.viewModel.input.initialized.value = ()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
    }

    private func bind() {
        self.viewModel.output.detail.lazyBind { [weak self] _ in
            self?.configureDetail()
        }
        
        self.viewModel.output.backdropURLs.lazyBind { [weak self] _ in
            self?.backdropCollectionView.reloadData()
            self?.backdropPageControl.numberOfPages = self?.viewModel.output.backdropURLs.value.count ?? 0
            self?.backdropPageControl.currentPage = 0
        }
        
        self.viewModel.output.castInfos.lazyBind { [weak self] _ in
            self?.castCollectionView.reloadData()
        }
        
        self.viewModel.output.posterURLs.lazyBind { [weak self] _ in
            self?.posterCollectionView.reloadData()
        }
        
        self.viewModel.output.currentPage.lazyBind { [weak self] currentPage in
            self?.backdropPageControl.currentPage = currentPage
        }
        
        self.viewModel.output.errorMessage.lazyBind { [weak self] message in
            guard let message else { return }
            self?.presentErrorAlert(message: message)
        }
        
        self.viewModel.output.synopSectionChanged.bind { [weak self] (info: (buttonTitle: String, numberOfLines: Int)) in
            self?.synopsisSection.accessoryButton?.setTitle(info.buttonTitle, for: .normal)
            self?.synopsisLabel.numberOfLines = info.numberOfLines
        }
        
        self.viewModel.output.backdropCollectionViewScrollToItem.lazyBind { index in
            
        }
    }
}

extension MovieDetailViewController {
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
        
        self.synopsisContainer.addSubview(self.synopsisLabel)
        self.synopsisLabel.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(16)
        }
        
        self.contentStack.addArrangedSubview(self.synopsisSection)
        self.synopsisLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(16)
            make.verticalEdges.equalToSuperview()
        }
        
        self.contentStack.addArrangedSubview(self.castSection)
        
        self.contentStack.addArrangedSubview(self.posterSection)

        configureSynopSection()
        configureCastSection()
        configurePosterSection()
        
        configureBackdropCollectionView()
        configureBackdropPageConntrol()
        configureCastCollectionView()
        configurePosterCollectionView()
    }
    
    private func configureSynopSection() {
        self.synopsisSection.setTitle("Synopsis")
        let buttonTitle = self.viewModel.output.synopSectionChanged.value.0
        let action = UIAction { [weak self] action in
            self?.viewModel.input.synopsisFoldToggleButtonTapped.value = ()
        }
        self.synopsisSection.setAccessoryButton(title: buttonTitle, action: action)
        self.synopsisSection.setContentView(self.synopsisContainer)
    }
    
    private func configureCastSection() {
        self.castSection.setTitle("Cast")
        self.castSection.setContentView(self.castCollectionView)
    }
    
    private func configurePosterSection() {
        self.posterSection.setTitle("Poster")
        self.posterSection.setContentView(self.posterCollectionView)
    }
    
    private func configureBackdropCollectionView() {
        self.backdropCollectionView.registerCellClass(BackdropCollectionViewCell.self)
        self.backdropCollectionView.dataSource = self
        self.backdropCollectionView.delegate = self
        self.backdropCollectionView.isPagingEnabled = true
        self.backdropCollectionView.showsHorizontalScrollIndicator = false
    }
    
    private func configureBackdropPageConntrol() {
        self.backdropPageControl.numberOfPages = self.viewModel.output.backdropURLs.value.count
        self.backdropPageControl.allowsContinuousInteraction = true
        self.backdropPageControl.backgroundStyle = .prominent
        
        let valueChangeAction = UIAction { [weak self] action in
            guard let control = action.sender as? UIPageControl else { return }
            self?.viewModel.input.backdropPageControlValueChanged.value = control.currentPage
        }
        self.backdropPageControl.addAction(valueChangeAction, for: .valueChanged)
    }
    
    @objc private func moveBackdropPage(to page: Int) {
        self.backdropCollectionView.scrollToItem(at: IndexPath(row: page, section: 0), at: .centeredHorizontally, animated: true)
    }
    
    private func configureCastCollectionView() {
        self.castCollectionView.registerCellClass(CastCollectionViewCell.self)
        self.castCollectionView.dataSource = self
        self.castCollectionView.delegate = self
        self.castCollectionView.backgroundColor = .clear
        self.castCollectionView.showsHorizontalScrollIndicator = false
    }
    
    private func configurePosterCollectionView() {
        self.posterCollectionView.registerCellClass(PosterCollectionViewCell.self)
        self.posterCollectionView.dataSource = self
        self.posterCollectionView.delegate = self
        self.posterCollectionView.backgroundColor = .clear
        self.posterCollectionView.showsHorizontalScrollIndicator = false
    }
}

extension MovieDetailViewController {
    private func configureDetail() {
        guard let detail = self.viewModel.output.detail.value else { return }
        self.navigationItem.title = detail.navigationTitle
        self.releaseDateTag.configure(with: detail.releaseDate ?? "") // TODO: 예외 처리
        self.voteTag.configure(with: "\(detail.voteAverage)")
        self.genreTag.configure(with: detail.genresText)
        self.synopsisLabel.text = detail.synopsis ?? "" // TODO: 예외 처리
        let button = LikeBarButtonItem(
            id: detail.movieID,
            liked: detail.movieIsLiked,
            action: { [weak self] _ in
                self?.viewModel.input.likeButtonTapped.value = ()
            }
        )
        self.navigationItem.rightBarButtonItem = button
    }
}

extension MovieDetailViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        switch collectionView {
        case self.backdropCollectionView:
            return self.viewModel.output.backdropURLs.value.count
        case self.castCollectionView:
            return self.viewModel.output.castInfos.value.count
        case self.posterCollectionView:
            return self.viewModel.output.posterURLs.value.count
        default:
            return 0
        }
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        switch collectionView {
        case self.backdropCollectionView:
            guard let cell: BackdropCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath) else { return UICollectionViewCell() }
            let url = self.viewModel.output.backdropURLs.value[indexPath.item]
            cell.configure(with: url)
            return cell
            
        case self.castCollectionView:
            guard let cell: CastCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath) else { return UICollectionViewCell() }
            let castInfo = self.viewModel.output.castInfos.value[indexPath.item]
            cell.configure(with: castInfo)
            return cell
            
        case self.posterCollectionView:
            guard let cell: PosterCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath) else { return UICollectionViewCell() }
            let posterURL = self.viewModel.output.posterURLs.value[indexPath.item]
            cell.configure(with: posterURL)
            return cell
            
        default:
            return UICollectionViewCell()
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView === self.backdropCollectionView else { return }
        let pageWidth = scrollView.bounds.width
        let offset = scrollView.contentOffset.x
        self.viewModel.input.scrollViewDidScroll.value = (pageWidth, offset)
    }
}
