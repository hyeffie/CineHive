//
//  GenreLabel.swift
//  CineHive
//
//  Created by Effie on 1/31/25.
//

import UIKit

final class GenreLabel: UIView {
    private let label = BaseLabel(font: CHFont.small)
    
    init(genreName: String) {
        super.init(frame: .zero)
        self.label.text = genreName
        configureViews()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureViews() {
        self.addSubview(self.label)
        self.label.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(2)
            make.horizontalEdges.equalToSuperview().inset(4)
        }
        
        self.configureRadius(to: 4)
        self.backgroundColor = CHColor.darkLabelBackground.withAlphaComponent(0.7)
    }
}
