//
//  PosterCollectionViewCell.swift
//  CineHive
//
//  Created by Effie on 2/1/25.
//

import UIKit

final class PosterCollectionViewCell: UICollectionViewCell {
    private let imageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = CHColor.darkLabelBackground
        imageView.configureRadius(to: 8)
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

extension PosterCollectionViewCell: ReusableCell {}
