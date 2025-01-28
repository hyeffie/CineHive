//
//  CHImage.swift
//  CineHive
//
//  Created by Effie on 1/24/25.
//

import UIKit

enum CHImageName {
    static let onboarding = "onboarding"
    static let profilePrefix = "profile_"
    
    static func profileImage(number: Int) -> String {
        return profilePrefix + String(number)
    }
}
