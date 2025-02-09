//
//  ProfileEditViewModel.swift
//  CineHive
//
//  Created by Effie on 2/9/25.
//

import Foundation

enum ProfileEditMode {
    case create
    case update
}

final class ProfileEditViewModel {
    // MARK: input
    
    // MARK: output
    let mode: Observable<ProfileEditMode>
    
    init(mode: ProfileEditMode) {
        self.mode = Observable(value: mode)
    }
}
