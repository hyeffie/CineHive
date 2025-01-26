//
//  BaseLabel.swift
//  CineHive
//
//  Created by Effie on 1/24/25.
//

import UIKit

class BaseLabel: UILabel {
    init(
        color: UIColor = .primaryText,
        font: UIFont,
        alignment: NSTextAlignment = .left,
        numberOfLines: Int = 0
    ) {
        super.init(frame: .zero)
        configureView(
            color: color,
            font: font,
            alignment: alignment,
            numberOfLines: numberOfLines
        )
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureView(
        color: UIColor,
        font: UIFont,
        alignment: NSTextAlignment = .left,
        numberOfLines: Int = 0
    ) {
        self.textColor = color
        self.font = font
        self.textAlignment = alignment
        self.numberOfLines = numberOfLines
    }
}
