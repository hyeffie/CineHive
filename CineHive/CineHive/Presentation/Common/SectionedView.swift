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
    
    private let contentUnavailableView = BaseLabel(
        color: CHColor.darkLabelBackground,
        font: CHFont.mediumBold,
        alignment: .center
    )
    
    var content: Content
    
    init(
        title: String,
        accessoryButtonInfo: (title: String, action: (UIButton) -> ())? = nil,
        content: Content,
        contentUnavailableMessage: String? = nil
    ) {
        if let accessoryButtonInfo {
            let action = UIAction(handler: { action in
                guard let button = action.sender as? UIButton else { return }
                accessoryButtonInfo.action(button)
            })
            self.button = UIButton(primaryAction: action)
            self.button?.setTitle(accessoryButtonInfo.title, for: .normal)
        } else {
            self.button = nil
        }
        
        self.content = content
        super.init(frame: .zero)
        self.titleLabel.text = title
        self.contentUnavailableView.text = contentUnavailableMessage
        configreViews()
        toggleContentAvailability(isAvailable: true)
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
            make.centerY.equalToSuperview()
        }
        
        titleContainer.snp.makeConstraints { make in
            make.height.equalTo(30)
        }
        
        titleContainer.setContentHuggingPriority(.required, for: .vertical)
        
        let containerStack = UIStackView()
        containerStack.axis = .vertical
        containerStack.alignment = .fill
        containerStack.spacing = 8
        
        containerStack.addArrangedSubview(titleContainer)
        containerStack.addArrangedSubview(self.content)
        
        self.addSubview(containerStack)
        containerStack.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        self.addSubview(self.contentUnavailableView)
        self.contentUnavailableView.snp.makeConstraints { make in
            make.edges.equalTo(self.content)
        }
        
        self.contentUnavailableView.backgroundColor = CHColor.mainBackground
    }
    
    func toggleContentAvailability(isAvailable: Bool) {
        self.button?.isHidden = !isAvailable
        self.contentUnavailableView.alpha = isAvailable ? 0 : 1
    }
}
