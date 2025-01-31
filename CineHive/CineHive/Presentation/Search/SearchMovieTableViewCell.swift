//
//  SearchMovieTableViewCell.swift
//  CineHive
//
//  Created by Effie on 1/31/25.
//

import UIKit

final class SearchMovieTableViewCell: UITableViewCell {
    private let posterImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.configureRadius(to: 8)
        return imageView
    }()
    
    private let titleLabel = BaseLabel(font: CHFont.mediumBold, numberOfLines: 2)
    
    private let releaseDateLabel = BaseLabel(font: CHFont.small)
    
    private let genreStack = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 2
        stack.alignment = .bottom
        return stack
    }()
    
    private let likeButton = LikeButton(frame: .zero)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureViews()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureViews() {
        let outerInset = 20
        
        self.contentView.addSubview(self.posterImageView)
        self.posterImageView.snp.makeConstraints { make in
            make.verticalEdges.leading.equalToSuperview().inset(outerInset)
            make.width.equalTo(self.posterImageView.snp.height).multipliedBy(3 / 4)
        }
        
        self.contentView.addSubview(self.titleLabel)
        self.titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(self.posterImageView.snp.trailing).offset(outerInset)
            make.top.equalTo(self.posterImageView).offset(4)
        }
        
        self.contentView.addSubview(self.releaseDateLabel)
        self.releaseDateLabel.snp.makeConstraints { make in
            make.top.equalTo(self.titleLabel.snp.bottom).offset(4)
            make.leading.equalTo(self.titleLabel)
        }
        
        self.contentView.addSubview(self.genreStack)
        self.genreStack.snp.makeConstraints { make in
            make.leading.equalTo(self.titleLabel)
            make.bottom.equalTo(self.posterImageView)
            make.height.equalTo(self.posterImageView).dividedBy(5)
        }
        
        self.contentView.addSubview(self.likeButton)
        self.likeButton.snp.makeConstraints { make in
            make.bottom.trailing.equalToSuperview().inset(outerInset)
            make.height.equalTo(self.posterImageView).dividedBy(5)
        }
    }
}

extension SearchMovieTableViewCell: ReusableCell {}
