//
//  FeaturedMovieCollectionViewCell.swift
//  CineHive
//
//  Created by Effie on 1/30/25.
//

import UIKit
import Kingfisher

final class FeaturedMovieCollectionViewCell: UICollectionViewCell {
    private let posterImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.configureRadius(to: 12)
        return imageView
    }()
    
    private let movieTitleLabel = BaseLabel(font: CHFont.largeBold)
    
    private let movieSynopsysLabel = BaseLabel(font: CHFont.small, numberOfLines: 2)
    
    private let likeButton = LikeButton(frame: .zero)
    
    private lazy var hStack = {
        let stack = UIStackView(arrangedSubviews: [self.movieTitleLabel, self.likeButton])
        stack.axis = .horizontal
        stack.alignment = .fill
        stack.distribution = .fill
        stack.spacing = 4
        return stack
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
        self.contentView.addSubview(self.posterImageView)
        self.posterImageView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.8)
        }
        
        self.contentView.addSubview(self.hStack)
        self.hStack.snp.makeConstraints { make in
            make.top.equalTo(self.posterImageView.snp.bottom).offset(8)
            make.horizontalEdges.equalToSuperview()
        }
        
        self.contentView.addSubview(self.movieSynopsysLabel)
        self.movieSynopsysLabel.snp.makeConstraints { make in
            make.top.equalTo(self.hStack.snp.bottom).offset(4)
            make.horizontalEdges.bottom.equalToSuperview()
        }
    }
    
    func configure(
        movieSummary: FeaturedMovieSummary,
        likeButtonAction: @escaping (Int) -> Void
    ) {
        self.posterImageView.kf.setImage(with: movieSummary.posterImageURL)
        self.movieTitleLabel.text = movieSummary.title
        self.movieSynopsysLabel.text = movieSummary.synopsys
        self.likeButton.configure(
            id: movieSummary.id,
            liked: movieSummary.liked,
            action: { movieID in likeButtonAction(movieID) }
        )
    }
}

extension FeaturedMovieCollectionViewCell: ReusableCell {}

struct FeaturedMovieSummary {
    let id: Int
    let posterImageURL: URL?
    let title: String
    let synopsys: String
    var liked: Bool
}
