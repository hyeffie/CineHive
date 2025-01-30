//
//  FeaturedMovieCollectionViewCell.swift
//  CineHive
//
//  Created by Effie on 1/30/25.
//

import UIKit

final class FeaturedMovieCollectionViewCell: UICollectionViewCell {
    private let posterImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.configureRadius(to: 10)
        return imageView
    }()
    
    private let movieTitleLabel = BaseLabel(font: CHFont.mediumBold)
    
    private let movieSynopsysLabel = BaseLabel(font: CHFont.small, numberOfLines: 2)
    
    private let likeButton: LikeButton
    
    init(likeButtonAction: @escaping (Bool) -> Void) {
        self.likeButton = LikeButton(action: likeButtonAction)
        super.init(frame: .zero)
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
            make.height.equalTo(self.posterImageView.snp.width).multipliedBy(40 / 27)
        }
        
        self.contentView.addSubview(self.movieTitleLabel)
        self.movieTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(self.posterImageView.snp.bottom).offset(8)
            make.leading.equalTo(self.posterImageView)
        }
        
        self.contentView.addSubview(self.likeButton)
        self.likeButton.snp.makeConstraints { make in
            make.verticalEdges.equalTo(self.movieTitleLabel)
            make.leading.equalTo(self.movieTitleLabel.snp.trailing).offset(4)
            make.trailing.equalToSuperview()
        }
        
        self.contentView.addSubview(self.movieSynopsysLabel)
        self.movieSynopsysLabel.snp.makeConstraints { make in
            make.top.equalTo(self.movieTitleLabel.snp.bottom).offset(4)
            make.horizontalEdges.bottom.equalToSuperview()
        }
    }
    
    func configure(with movieSummary: FeaturedMovieSummary) {
        
    }
}

extension FeaturedMovieCollectionViewCell: ReusableCell {}

struct FeaturedMovieSummary {
    let posterImageURL: URL?
}
