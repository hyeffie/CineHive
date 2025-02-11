//
//  BaseViewModelProtocol.swift
//  CineHive
//
//  Created by Effie on 2/10/25.
//

import Foundation

protocol BaseViewModelProtocol {
    associatedtype Input
    associatedtype Output
    
    var input: Input { get }
    var output: Output { get }
    
    func transform()
}
