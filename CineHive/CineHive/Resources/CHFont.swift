//
//  CHFont.swift
//  CineHive
//
//  Created by Effie on 1/24/25.
//

import UIKit

struct CHFont {
    static let small = CHFont(ofSize: 12, weight: .regular)
    static let medium = CHFont(ofSize: 14, weight: .regular)
    static let large = CHFont(ofSize: 16, weight: .regular)
    
    static let smallBold = CHFont(ofSize: 12, weight: .bold)
    static let mediumBold = CHFont(ofSize: 14, weight: .bold)
    static let largeBold = CHFont(ofSize: 16, weight: .bold)
    
    let value: UIFont
    
    private init(ofSize size: CGFloat, weight: UIFont.Weight) {
        self.value = UIFont.systemFont(ofSize: size, weight: weight)
    }
}
