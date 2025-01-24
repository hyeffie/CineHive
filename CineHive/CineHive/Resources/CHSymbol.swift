//
//  CHSymbol.swift
//  CineHive
//
//  Created by Effie on 1/24/25.
//

import UIKit

struct CHSymbol {
    static let camera = CHSymbol(name: "camera.fill")
    static let xmark = CHSymbol(name: "xmark")
    static let emptyHeart = CHSymbol(name: "heart")
    static let heart = CHSymbol(name: "heart.fill")
    static let star = CHSymbol(name: "star.fill")
    static let search = CHSymbol(name: "magnifyingglass")
    static let calendar = CHSymbol(name: "calendar")
    static let film = CHSymbol(name: "film.fill")
    static let films = CHSymbol(name: "film.stak.fill")
    static let popcorn = CHSymbol(name: "popcorn")
    static let profile = CHSymbol(name: "person.crop.circle")
    
    let value: UIImage?
    
    private init(name: String) {
        self.value = UIImage(systemName: name)
    }
}
