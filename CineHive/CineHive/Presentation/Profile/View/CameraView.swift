//
//  CameraView.swift
//  CineHive
//
//  Created by Effie on 1/24/25.
//

import UIKit

final class CameraView: UIView {
    private let cameraImageView = {
        let imageView = UIImageView()
        imageView.image = CHSymbol.camera.value
        imageView.tintColor = CHColor.primaryText
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureView() {
        self.addSubview(self.cameraImageView)
        let height = self.frame.height
        self.cameraImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.6)
            make.height.equalToSuperview().multipliedBy(0.5)
        }
        self.backgroundColor = CHColor.theme
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.makeCircle()
    }
}
