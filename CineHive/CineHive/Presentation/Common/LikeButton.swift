//
//  LikeButton.swift
//  CineHive
//
//  Created by Effie on 1/30/25.
//

import UIKit

final class LikeButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureView() {
        self.tintColor = CHColor.theme
        self.setImage(CHSymbol.emptyHeart.value, for: .normal)
        self.setImage(CHSymbol.heart.value, for: .selected)
        
//        self.configurationUpdateHandler = { button in
//            button.configuration?.baseForegroundColor = CHColor.theme
//            switch button.state {
//            case .selected:
//                button.configuration?.image = CHSymbol.heart.value
//            case .normal:
//                button.configuration?.image = CHSymbol.emptyHeart.value
//            default:
//                return
//            }
//        }
        
        self.snp.makeConstraints { make in
            make.width.equalTo(self.snp.height)
        }
    }
    
    func configure(
        liked: Bool,
        action: @escaping (Bool) -> Void
    ) {
        self.isSelected = liked
        
        let action = UIAction { [weak self] _ in
            guard let self else { return }
            self.isSelected.toggle()
            action(self.isSelected)
        }
        self.addAction(action, for: .touchUpInside)
    }
}
