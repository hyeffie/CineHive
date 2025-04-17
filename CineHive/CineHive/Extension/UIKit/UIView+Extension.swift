//
//  UIView+Extension.swift
//  CineHive
//
//  Created by Effie on 1/24/25.
//

import UIKit

extension UIView {
    func makeCircle() {
        self.clipsToBounds = true
        self.layer.cornerRadius = self.frame.height / 2
    }
    
    func configureRadius(to radius: CGFloat) {
        self.clipsToBounds = true
        self.layer.cornerRadius = radius
    }
}
