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
        imageView.backgroundColor = CHColor.lightLabelBackground
        return imageView
    }()
    
    private let titleLabel = BaseLabel(font: CHFont.mediumBold, numberOfLines: 2)
    
    private let releaseDateLabel = BaseLabel(font: CHFont.small)
    
    private let genreStack = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 2
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
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.genreStack.removeAllArrangedSubviews()
    }
    
    private func configureViews() {
        let outerInset = 20
        
        self.contentView.addSubview(self.posterImageView)
        self.posterImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(outerInset)
            make.verticalEdges.equalToSuperview().inset(outerInset)
            make.width.equalTo(self.posterImageView.snp.height).multipliedBy(0.75)
        }
        
        self.contentView.addSubview(self.titleLabel)
        self.titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(self.posterImageView.snp.trailing).offset(outerInset)
            make.top.equalTo(self.posterImageView).offset(4)
            make.trailing.equalToSuperview().inset(20)
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
            make.height.greaterThanOrEqualTo(self.posterImageView).dividedBy(5)
        }
        self.genreStack.setContentHuggingPriority(.required, for: .horizontal)
        self.genreStack.setContentCompressionResistancePriority(.required, for: .horizontal)
        
        self.contentView.addSubview(self.likeButton)
        self.likeButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(outerInset)
            make.trailing.equalToSuperview().inset(outerInset)
            make.height.equalTo(self.posterImageView).dividedBy(5)
            make.leading.greaterThanOrEqualTo(self.genreStack.snp.trailing).offset(10)
        }
        
        self.backgroundColor = .clear
        
        let selectedBackgroundView = UIView(frame: self.bounds)
        selectedBackgroundView.backgroundColor = .clear
        self.selectedBackgroundView = selectedBackgroundView
    }
    
    func configure(
        summary: SearchMovieSummary,
        likeButtonAction: @escaping (Int) -> Void
    ) {
        self.posterImageView.kf.setImage(with: summary.posterURL)
        self.titleLabel.text = summary.title
        self.releaseDateLabel.text = summary.dateString
        addGenreLabels(summary.genres)
        self.likeButton.configure(
            id: summary.id,
            liked: summary.liked,
            action: likeButtonAction
        )
        self.layoutIfNeeded()
    }
    
    private func addGenreLabels(_ genreNames: [String]) {
        genreNames.forEach { genreName in
            let label = GenreLabel(genreName: genreName)
            self.genreStack.addArrangedSubview(label)
        }
    }
}

extension SearchMovieTableViewCell: ReusableCell {}
