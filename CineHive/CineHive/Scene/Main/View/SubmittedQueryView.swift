//
//  SubmittedQueryView.swift
//  CineHive
//
//  Created by Effie on 1/31/25.
//

import UIKit

final class SubmittedQueryView: UIView {
    private let query: String
    private let tapHandler: (String) -> Void
    
    private let queryLabel = BaseLabel(color: CHColor.mainBackground, font: CHFont.medium)
    
    private let deleteButton = {
        let button = UIButton()
        button.setTitle("", for: .normal)
        let symbolConfig = UIImage.SymbolConfiguration(scale: .small)
        let symbol = CHSymbol.xmark.value?.applyingSymbolConfiguration(symbolConfig)
        button.setImage(symbol, for: .normal)
        button.tintColor = CHColor.mainBackground
        return button
    }()
    
    init(
        query: String,
        tapHandler: @escaping (String) -> Void,
        deleteHandler: @escaping (String) -> Void
    ) {
        self.query = query
        self.tapHandler = tapHandler
        super.init(frame: .zero)
        self.queryLabel.text = self.query
        configureViews()
        addActionToButton(deletionHandler: deleteHandler)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.makeCircle()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        self.tapHandler(self.query)
    }
    
    private func configureViews() {
        let hOuterInset = 12
        let vOuterInset = 8
        self.addSubview(self.queryLabel)
        self.queryLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(hOuterInset)
            make.verticalEdges.equalToSuperview().inset(vOuterInset)
        }
        
        self.addSubview(self.deleteButton)
        self.deleteButton.snp.makeConstraints { make in
            make.leading.equalTo(self.queryLabel.snp.trailing).offset(4)
            make.centerY.equalTo(self.queryLabel)
            make.height.equalToSuperview()
            make.trailing.equalToSuperview().inset(hOuterInset)
        }
        
        self.backgroundColor = CHColor.lightLabelBackground
    }

    private func addActionToButton(
        deletionHandler: @escaping (String) -> Void
    ) {
        
        let deletionAction = UIAction { [weak self] _ in
            guard let self else { return }
            deletionHandler(self.query)
            self.removeFromSuperview()
        }
        self.deleteButton.addAction(deletionAction, for: .touchUpInside)
    }
}
