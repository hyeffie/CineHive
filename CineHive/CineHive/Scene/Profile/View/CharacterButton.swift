//
//  CharacterButton.swift
//  CineHive
//
//  Created by Effie on 2/10/25.
//

import UIKit

final class CharacterButton: UIButton {
    private let selectionDelegate: ButtonSelectionDelegate
    
    init(
        character: Character,
        selectionDelegate: any ButtonSelectionDelegate
    ) {
        self.selectionDelegate = selectionDelegate
        super.init(frame: .zero)
        configureView(title: "\(character)")
        addEventHandler()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureView(title: String) {
        self.snp.makeConstraints { make in
            make.size.equalTo(44)
        }
        
        var configuration = UIButton.Configuration.bordered()
        
        var attributeContainer = AttributeContainer()
        attributeContainer.font = CHFont.largeBold
        configuration.cornerStyle = .capsule
        configuration.background.strokeColor = CHColor.lightLabelBackground
        
        self.configuration = configuration
        
        self.configurationUpdateHandler = { button in
            var attributeContainer = AttributeContainer()
            attributeContainer.font = CHFont.large
            switch button.state {
            case .normal:
                attributeContainer.foregroundColor = CHColor.lightLabelBackground
                
                button.configuration?.background.strokeWidth = 2
                button.configuration?.background.backgroundColor = .clear
            case .selected:
                attributeContainer.foregroundColor = CHColor.primaryText
                button.configuration?.background.strokeWidth = 0
                button.configuration?.background.backgroundColor = CHColor.validCompleteButton
            default:
                return
            }
            button.configuration?.attributedTitle = AttributedString(title, attributes: attributeContainer)
        }
    }
    
    private func addEventHandler() {
        self.addTarget(self, action: #selector(self.toggle), for: .touchUpInside)
    }
    
    @objc private func toggle() {
        if self.isSelected {
            self.selectionDelegate.shouldDeSelect(self)
        } else {
            self.selectionDelegate.shouldSelect(self)
        }
    }
}

extension CharacterButton: SelectableView {
    func select() {
        self.isSelected = true
    }
    
    func deselect() {
        self.isSelected = false
    }
}
