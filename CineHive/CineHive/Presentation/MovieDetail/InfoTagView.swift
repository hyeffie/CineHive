//
//  InfoTagView.swift
//  CineHive
//
//  Created by Effie on 1/31/25.
//

import UIKit

final class InfoTagView: UIView {
    private let imageView = {
        let view = UIImageView()
        view.tintColor = CHColor.darkLabelBackground
        return view
    }()
    
    private let label = BaseLabel(color: CHColor.darkLabelBackground, font: CHFont.small)
    
    init(symbol: CHSymbol) {
        super.init(frame: .zero)
        let symbolConfig = UIImage.SymbolConfiguration(scale: .medium)
        self.imageView.image = symbol.value?.applyingSymbolConfiguration(symbolConfig)
        configureViews()
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
        
        self.imageView.snp.makeConstraints { make in
            make.size.equalTo(12)
        }
        
        self.addSubview(stack)
        stack.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(10)
            make.verticalEdges.equalToSuperview()
        }
        
        self.backgroundColor = CHColor.mainBackground
    }
    
    func configure(with text: String) {
        self.label.text = text
    }
}
