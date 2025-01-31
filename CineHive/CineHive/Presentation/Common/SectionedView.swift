//
//  SectionedView.swift
//  CineHive
//
//  Created by Effie on 1/30/25.
//

import UIKit

final class SectionedView<Content: UIView>: UIView {
    private let titleLabel = BaseLabel(font: CHFont.largeBold)
    
    private let button: UIButton?
    
    let content: Content
    
    init(
        title: String,
        accessoryButtonInfo: (title: String, action: () -> ())? = nil,
        content: Content
    ) {
        if let accessoryButtonInfo {
            let action = UIAction(handler: { _ in accessoryButtonInfo.action() })
            self.button = UIButton(primaryAction: action)
            self.button?.setTitle(accessoryButtonInfo.title, for: .normal)
        } else {
            self.button = nil
        }
        
        self.content = content
        super.init(frame: .zero)
        self.titleLabel.text = title
        configreViews()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configreViews() {
        let titleStack = UIStackView(arrangedSubviews: [self.titleLabel])
        titleStack.axis = .horizontal
        titleStack.alignment = .center
        
        if let button {
            titleStack.addArrangedSubview(button)
            button.titleLabel?.font = CHFont.medium
            button.setTitleColor(CHColor.theme, for: .normal)
            button.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        }
        
        let titleContainer = UIView()
        titleContainer.addSubview(titleStack)
        titleStack.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(16)
            make.verticalEdges.equalToSuperview()
        }
        
        let containerStack = UIStackView(arrangedSubviews: [titleContainer])
        containerStack.axis = .vertical
        containerStack.alignment = .fill
        containerStack.spacing = 8
        
        containerStack.addArrangedSubview(self.content)
        
        self.addSubview(containerStack)
        containerStack.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
