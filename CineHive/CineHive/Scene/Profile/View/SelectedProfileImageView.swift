//
//  SelectedProfileImageView.swift
//  CineHive
//
//  Created by Effie on 1/24/25.
//

import UIKit

final class SelectedProfileImageView: UIView {
    private let profileImageView: ProfileImageView
    
    private let cameraView = CameraView(frame: .zero)
    
    private let tapHandler: (() -> Void)?
    
    init(
        imageName: String? = nil,
        tapHandler: (() -> Void)? = nil
    ) {
        self.profileImageView = ProfileImageView(imageName: imageName)
        self.tapHandler = tapHandler
        super.init(frame: .zero)
        configureViews()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureViews() {
        self.addSubview(self.profileImageView)
        self.profileImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        self.addSubview(self.cameraView)
        self.cameraView.snp.makeConstraints { make in
            make.height.equalTo(self.cameraView.snp.width)
            make.bottom.trailing.equalTo(self.profileImageView)
            make.height.equalTo(self.profileImageView).multipliedBy(0.3)
        }
        
        self.profileImageView.setState(isSelected: true)
        addTapGestureRecognizer()
    }
    
    private func addTapGestureRecognizer() {
        let tapRecognizer = UITapGestureRecognizer()
        tapRecognizer.addTarget(self, action: #selector(handleTap))
        self.addGestureRecognizer(tapRecognizer)
    }
    
    @objc private func handleTap() {
        self.tapHandler?()
    }
    
    func configureImage(number: Int) {
        let imageName = CHImageName.profileImage(number: number)
        self.profileImageView.configureImage(name: imageName)
    }
}
