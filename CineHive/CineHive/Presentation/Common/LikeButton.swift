//
//  LikeButton.swift
//  CineHive
//
//  Created by Effie on 1/30/25.
//

import UIKit

final class LikeButton: UIButton {
    init(
        action: @escaping (Bool) -> Void
    ) {
        super.init(frame: .zero)
        let action = UIAction { [weak self] _ in
            guard let self else { return }
            let liked = self.isSelected
            action(liked)
        }
        self.addAction(action, for: .touchUpInside)
        
        configureView()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureView() {
        self.configurationUpdateHandler = { button in
            button.configuration?.title = ""
            button.configuration?.baseForegroundColor = CHColor.theme
            
            switch button.state {
            case .normal:
                button.configuration?.image = CHSymbol.heart.value
            case .disabled:
                button.configuration?.image = CHSymbol.emptyHeart.value
            default:
                return
            }
        }
    }
}
