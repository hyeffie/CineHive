//
//  ProfileImageView.swift
//  CineHive
//
//  Created by Effie on 1/24/25.
//

import UIKit

final class ProfileImageView: UIImageView {
    init(imageName: String) {
        super.init(frame: .zero)
        self.image = UIImage(named: imageName)
        configureView()
        setState(isSelected: false)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        makeCircle()
    }
    
    private func configureView() {
        self.snp.makeConstraints { make in
            make.height.equalTo(self.snp.width)
        }
        
        self.contentMode = .scaleAspectFill
    }
    
    func setState(isSelected: Bool) {
        if isSelected {
            self.layer.borderColor = CHColor.theme.value.cgColor
            self.layer.borderWidth = 3
            self.alpha = 1.0
        } else {
            self.layer.borderColor = CHColor.darkLabelBackground.value.cgColor
            self.layer.borderWidth = 1
            self.alpha = 0.5
        }
    }
}

#Preview {
    let view = ProfileImageView(imageName: CHImageName.profilePrefix + "0")
    view.setState(isSelected: true)
    return view
}
