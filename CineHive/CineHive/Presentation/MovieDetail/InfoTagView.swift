//
//  InfoTagView.swift
//  CineHive
//
//  Created by Effie on 1/31/25.
//

import UIKit

final class InfoTagView: UIView {
    private let imageView = UIImageView()
    
    private let label = BaseLabel(color: CHColor.darkLabelBackground, font: CHFont.small)
    
    init(symbol: UIImage, text: String) {
        super.init(frame: .zero)
        
        let symbolConfig = UIImage.SymbolConfiguration(scale: .small)
        self.imageView.image = symbol.applyingSymbolConfiguration(symbolConfig)
        self.label.text = text
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureViews() {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 4
        stack.alignment = .center
        
        stack.addArrangedSubview(self.imageView)
        stack.addArrangedSubview(self.label)
        
        self.addSubview(stack)
        stack.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(10)
            make.verticalEdges.equalToSuperview()
        }
        
        self.backgroundColor = CHColor.mainBackground
    }
}
