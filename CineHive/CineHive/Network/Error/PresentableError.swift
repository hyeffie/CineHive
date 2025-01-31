//
//  PresentableError.swift
//  CineHive
//
//  Created by Effie on 1/30/25.
//

protocol PresentableError: Error {
    var message: String { get }
}
