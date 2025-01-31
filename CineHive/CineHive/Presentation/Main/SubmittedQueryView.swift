//
//  SubmittedQueryView.swift
//  CineHive
//
//  Created by Effie on 1/31/25.
//

import UIKit

final class SubmittedQueryView: UIView {
    private let queryLabel = BaseLabel(color: CHColor.mainBackground, font: CHFont.medium)
    
    private let deleteButton = {
        let button = UIButton()
        button.setTitle("", for: .normal)
        let symbolConfig = UIImage.SymbolConfiguration(scale: .medium)
        let symbol = CHSymbol.xmark.value?.applyingSymbolConfiguration(symbolConfig)
        button.setImage(symbol, for: .normal)
        button.tintColor = CHColor.mainBackground
        return button
    }()
    
    init(query: String) {
        super.init(frame: .zero)
        self.queryLabel.text = query
        configureViews()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureViews() {
        let outerInset = 8
        self.addSubview(self.queryLabel)
        self.queryLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(outerInset)
            make.verticalEdges.equalToSuperview().inset(outerInset)
        }
        
        self.addSubview(self.deleteButton)
        self.deleteButton.snp.makeConstraints { make in
            make.leading.equalTo(self.queryLabel.snp.trailing).offset(4)
            make.centerY.equalTo(self.queryLabel)
            make.height.equalToSuperview()
            make.trailing.equalToSuperview().inset(outerInset)
        }
        
        self.backgroundColor = CHColor.lightLabelBackground
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.makeCircle()
    }
}

extension SubmittedQueryView: SelectableView {
    func select() {
        
    }
    
    func deselect() {
        
    }
}

#Preview {
    SubmittedQueryView(query: "최근 검색어")
}
