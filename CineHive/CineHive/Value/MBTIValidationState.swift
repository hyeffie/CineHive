//
//  MBTIValidationState.swift
//  CineHive
//
//  Created by Effie on 2/10/25.
//

import Foundation

enum MBTIValidationState {
    case invalid
    case valid(_ mbti: UserMBTI)
    
    var isValid: Bool {
        switch self {
        case .invalid: return false
        case .valid: return true
        }
    }
}
