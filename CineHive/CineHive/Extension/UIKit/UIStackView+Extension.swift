//
//  UIStackView+Extension.swift
//  CineHive
//
//  Created by Effie on 1/31/25.
//

import UIKit

extension UIStackView {
    func removeAllArrangedSubviews() {
        self.arrangedSubviews.forEach { view in
            view.removeFromSuperview()
        }
    }
}
