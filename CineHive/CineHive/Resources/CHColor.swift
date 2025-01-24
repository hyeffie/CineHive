//
//  CHColor.swift
//  CineHive
//
//  Created by Effie on 1/24/25.
//

import UIKit

struct CHColor {
    static let darkLabelBackground = CHColor(name: "dark-label-background")
    static let lightLabelBackground = CHColor(name: "light-label-background")
    static let mainBackground = CHColor(name: "main-background")
    static let theme = CHColor(name: "hive-theme")
    static let primaryText = CHColor(name: "primary-text")
    
    let value: UIColor
    
    private init(name: String) {
        self.value = UIColor(named: name) ?? UIColor.clear
    }
}
