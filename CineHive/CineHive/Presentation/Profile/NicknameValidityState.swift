//
//  NicknameValidityState.swift
//  CineHive
//
//  Created by Effie on 1/28/25.
//

import Foundation

enum NicknameValidityState {
    enum InvalidState {
        case invalidLength
        case invalidCharacter
        case numberContained
        
        var message: String {
            switch self {
            case .invalidLength:
                return "2글자 이상 10글자 미만으로 설정해주세요"
            case .invalidCharacter:
                return "닉네임에 @, #, $, % 는 포함할 수 없어요"
            case .numberContained:
                return "닉네임에 숫자는 포함할 수 없어요"
            }
        }
    }
    
    case valid
    case invalid(_ state: InvalidState)
    
    var message: String {
        switch self {
        case .valid:
            return ""
        case .invalid(let state):
            return state.message
        }
    }
    
    var isEnabled: Bool {
        switch self {
        case .valid:
            return true
        case .invalid:
            return false
        }
    }
}
