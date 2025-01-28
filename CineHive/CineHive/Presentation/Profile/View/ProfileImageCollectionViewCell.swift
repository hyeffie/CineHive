//
//  ProfileImageCollectionViewCell.swift
//  CineHive
//
//  Created by Effie on 1/28/25.
//

import UIKit

final class ProfileImageCollectionViewCell: UICollectionViewCell {
    private let imageView = ProfileImageView(imageName: nil)
    
    override var isSelected: Bool {
        didSet { configureState() }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureView() {
        self.contentView.addSubview(self.imageView)
        self.imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func configureImage(imageNumber: Int) {
        let imageName = CHImageName.profileImage(number: imageNumber)
        self.imageView.configureImage(name: imageName)
    }
    
    private func configureState() {
        self.imageView.setState(isSelected: self.isSelected)
    }
}

extension ProfileImageCollectionViewCell: ReusableCell {}
