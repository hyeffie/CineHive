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
    
    init(imageName: String?) {
        self.profileImageView = ProfileImageView(imageName: imageName)
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
            make.verticalEdges.equalToSuperview()
            make.leading.equalToSuperview()
        }
        
        self.addSubview(self.cameraView)
        self.cameraView.snp.makeConstraints { make in
            make.height.equalTo(self.cameraView.snp.width)
            make.bottom.trailing.equalTo(self.profileImageView)
            make.height.equalTo(self.profileImageView).multipliedBy(0.3)
        }
    }
    
    func configureImage(name: String) {
        self.profileImageView.configureImage(name: name)
    }
}

#Preview {
    let view = SelectedProfileImageView(imageName: CHImageName.profilePrefix + "1")
    return view
}
