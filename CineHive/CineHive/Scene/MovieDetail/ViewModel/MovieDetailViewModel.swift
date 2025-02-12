//
//  MovieDetailViewModel.swift
//  CineHive
//
//  Created by Effie on 2/12/25.
//

import Foundation

final class MovieDetailViewModel: BaseViewModelProtocol {
    struct Input {
        
        
    }
    
    struct Output {
        
    }
    
    private struct Privates {
        
    }
    
    private(set) var input: Input
    
    private(set) var output: Output
    
    private var privates: Privates
    
    private let profileManager: UserProfileManager
    
    private let networkRequester: NetworkManager
    
    init(
        profileManager: UserProfileManager,
        networkRequester: NetworkManager
    ) {
        self.input = Input()
        self.output = Output()
        self.privates = Privates()
        self.profileManager = profileManager
        self.networkRequester = networkRequester
        
        transform()
    }
    
    func transform() {
        
    }
}
