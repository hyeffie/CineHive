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
    }
    
    private func configureDetail() {
        if let releaseDate = self.movieDetail.releaseDate { self.releaseDateTag.configure(with: releaseDate) }
        if let voteAverage = self.movieDetail.voteAverage { self.voteTag.configure(with: "\(voteAverage)") }
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
