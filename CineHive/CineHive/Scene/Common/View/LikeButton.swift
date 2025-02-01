//
//  LikeButton.swift
//  CineHive
//
//  Created by Effie on 1/30/25.
//

import UIKit

final class LikeButton: UIButton {
    private var tapAction: (() -> Void)? = nil
    
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
        
        self.snp.makeConstraints { make in
            make.width.equalTo(self.snp.height)
        }
        
        self.isSelected = false
        self.addTarget(self, action: #selector(doAction), for: .touchUpInside)
    }
    
    func configure(
        id: Int,
        liked: Bool,
        action: @escaping (Int) -> Void
    ) {
        self.isSelected = liked
        self.tapAction = { [weak self] in
            guard let self else { return }
            self.isSelected.toggle()
            action(id)
        }
    }
    
    @objc private func doAction() {
        self.tapAction?()
    }
}
