//
//  SectionView.swift
//  CineHive
//
//  Created by Effie on 2/11/25.
//

import UIKit

final class SectionView<ContentView: UIView>: UIView {
    private var titleLabel = BaseLabel(font: CHFont.largeBold)
    
    var accessoryButton: UIButton?

    var contentView: ContentView?
    
    private var contentUnavailableView: ContentUnavailableView? = nil
    
    private let titleStack = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .center
        return stack
    }()
    
    private let titleContainer = UIView()
    
    private let contentContainer = UIView()
    
    private let containerStack = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .fill
        stack.spacing = 8
        return stack
    }()
    
    var contentIsAvailable: ContentAvailablilty = .available {
        didSet {
            self.configureContentAvailability()
        }
    }
    
    init(contentHeight: CGFloat? = nil) {
        super.init(frame: .zero)
        configreViews(contentHeight: contentHeight)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configreViews(contentHeight: CGFloat?) {
        self.titleStack.addArrangedSubview(self.titleLabel)
        
        self.titleContainer.addSubview(self.titleStack)
        self.titleStack.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
        }
        
        self.containerStack.addArrangedSubview(titleContainer)
        self.titleContainer.snp.makeConstraints { make in
            make.height.equalTo(36)
        }
        self.titleContainer.setContentHuggingPriority(.required, for: .vertical)
        
        self.containerStack.addArrangedSubview(self.contentContainer)
        if let contentHeight {
            self.contentContainer.snp.makeConstraints { make in
                make.height.equalTo(contentHeight)
            }
        }
        
        self.addSubview(containerStack)
        self.containerStack.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func configureContentAvailability() {
        self.contentUnavailableView?.removeFromSuperview()
        
        switch self.contentIsAvailable {
        case .available:
            break
        case .unavailable(let state):
            let unavailableView = ContentUnavailableView(message: state.displayingMessage)
            self.contentUnavailableView = unavailableView
            
            self.addSubview(unavailableView)
            unavailableView.snp.makeConstraints({ make in
                make.edges.equalTo(self.contentContainer)
            })
        }
    }
    
    func setTitle(_ title: String) {
        self.titleLabel.text = title
    }
    
    func setAccessoryButton(title: String, action: UIAction) {
        if let existingButton = self.accessoryButton {
            existingButton.removeFromSuperview()
            self.accessoryButton = nil
        }
        
        let newButton = makeAccessoryButton(title: title, action: action)
        self.accessoryButton = newButton
        self.titleStack.addArrangedSubview(newButton)
        newButton.setContentHuggingPriority(.defaultHigh, for: .horizontal)
    }
    
    private func makeAccessoryButton(title: String, action: UIAction) -> UIButton {
        let button = UIButton()
        let styledTitle = NSAttributedString(
            string: title,
            attributes: [
                .font: CHFont.smallBold,
                .foregroundColor: CHColor.theme,
            ]
        )
        button.setAttributedTitle(styledTitle, for: .normal)
        button.addAction(action, for: .touchUpInside)
        return button
    }
    
    func setContentView(_ newContentView: ContentView) {
        if let existingContentView = self.contentView {
            existingContentView.removeFromSuperview()
            self.contentView = nil
        }
        
        self.contentView = newContentView
        self.contentContainer.addSubview(newContentView)
        newContentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
