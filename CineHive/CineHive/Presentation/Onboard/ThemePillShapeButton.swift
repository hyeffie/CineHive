//
//  ThemePillShapeButton.swift
//  CineHive
//
//  Created by Effie on 1/24/25.
//

import UIKit

final class ThemePillShapeButton: UIButton {
    init(title: String) {
        super.init(frame: .zero)
        self.setTitle(title, for: .normal)
        configureView()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureView() {
        self.snp.makeConstraints { make in
            make.height.equalTo(44)
        }
        
        self.setTitleColor(CHColor.theme, for: .normal)
        self.layer.borderColor = CHColor.theme.cgColor
        self.layer.borderWidth = 2
        self.titleLabel?.font = CHFont.largeBold
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.makeCircle()
    }
}
