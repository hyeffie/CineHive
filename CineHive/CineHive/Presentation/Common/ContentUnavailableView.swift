//
//  ContentUnavailableView.swift
//  CineHive
//
//  Created by Effie on 2/1/25.
//

import UIKit

final class ContentUnavailableView: UIView {
    private let messageLabel = BaseLabel(
        color: CHColor.lightLabelBackground,
        font: CHFont.mediumBold,
        alignment: .center
    )
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureViews()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureViews() {
        self.addSubview(self.messageLabel)
        self.messageLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(20)
        }
    }
    
    func configure(message: String) {
        self.messageLabel.text = message
    }
}
