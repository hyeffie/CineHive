//
//  CastCollectionViewCell.swift
//  CineHive
//
//  Created by Effie on 2/1/25.
//

import UIKit

final class CastCollectionViewCell: UICollectionViewCell {
    private let profileImage = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = CHColor.darkLabelBackground
        return imageView
    }()
    
    private let nameLabel = BaseLabel(font: CHFont.mediumBold, numberOfLines: 2)
    
    private let characterLabel = BaseLabel(font: CHFont.small, numberOfLines: 1)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureViews()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.profileImage.makeCircle()
    }
    
    private func configureViews() {
        self.contentView.addSubview(self.profileImage)
        
        self.profileImage.snp.makeConstraints { make in
            make.leading.verticalEdges.equalToSuperview()
            make.width.equalTo(self.profileImage.snp.height)
        }
        
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 6
        stack.alignment = .leading
        
        stack.addArrangedSubview(self.nameLabel)
        stack.addArrangedSubview(self.characterLabel)
        
        self.contentView.addSubview(stack)
        stack.snp.makeConstraints { make in
            make.leading.equalTo(self.profileImage.snp.trailing).offset(8)
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        
        self.backgroundColor = .clear
    }
    
    func configure(with cast: CastInfo) {
        self.profileImage.kf.setImage(with: cast.profileURL)
        self.nameLabel.text = cast.name
        self.characterLabel.text = cast.character
    }
    
    func layoutImageView() {
        self.profileImage.layoutIfNeeded()
    }
}

extension CastCollectionViewCell: ReusableCell {}
