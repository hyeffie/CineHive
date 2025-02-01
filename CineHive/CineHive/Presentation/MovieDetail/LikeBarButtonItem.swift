//
//  LikeBarButtonItem.swift
//  CineHive
//
//  Created by Effie on 2/1/25.
//

import UIKit

final class LikeBarButtonItem: UIBarButtonItem {
    private let likeButton = LikeButton(frame: .zero)

    init(id: Int, liked: Bool, action: @escaping (Int) -> Void) {
        super.init()
        
        likeButton.configure(id: id, liked: liked, action: action)
        self.customView = likeButton
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
