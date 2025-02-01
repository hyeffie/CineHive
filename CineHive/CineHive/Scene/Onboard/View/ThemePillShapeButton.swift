//
//  ThemePillShapeButton.swift
//  CineHive
//
//  Created by Effie on 1/24/25.
//

import UIKit

final class ThemePillShapeButton: UIButton {
    init(title: String) {
        super.init(frame: .zero)
        configureView(title: title)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureView(title: String) {
        self.snp.makeConstraints { make in
            make.height.equalTo(44)
        }
        
        var configuration = UIButton.Configuration.bordered()
        
        var attributeContainer = AttributeContainer()
        attributeContainer.font = CHFont.largeBold
        configuration.cornerStyle = .capsule
        configuration.baseBackgroundColor = .clear
        configuration.background.strokeWidth = 2
        
        self.configuration = configuration
        
        self.configurationUpdateHandler = { button in
            var attributeContainer = AttributeContainer()
            attributeContainer.font = CHFont.largeBold
            switch button.state {
            case .normal:
                attributeContainer.foregroundColor = CHColor.theme
                button.configuration?.background.strokeColor = CHColor.theme
            case .disabled:
                attributeContainer.foregroundColor = CHColor.darkLabelBackground
                button.configuration?.background.strokeColor = CHColor.darkLabelBackground
            default:
                return
            }
            button.configuration?.attributedTitle = AttributedString(title, attributes: attributeContainer)
        }
    }
}
