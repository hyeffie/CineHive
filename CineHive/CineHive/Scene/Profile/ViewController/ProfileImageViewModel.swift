//
//  ProfileImageViewModel.swift
//  CineHive
//
//  Created by Effie on 2/9/25.
//

import Foundation

final class ProfileImageViewModel {
    // MARK: inputs
    let viewDidLoad: Observable<Void> = Observable(value: ())
    
    let didSelectCell: Observable<Int?> = Observable(value: nil)
    
    // MARK: outputs
    let navigationTitle: Observable<String> = Observable(value: "")
    
    let imageNumberRange: Observable<Range<Int>> = Observable(value: (0..<12))
    
    let selectedImageNumber: Observable<Int>
    
    // MARK: privates
    private let imageSelectionHandler: (Int) -> Void
    
    init(
        selectedImageNumber: Int,
        imageSelectionHandler: @escaping (Int) -> Void
    ) {
        self.selectedImageNumber = Observable(value: selectedImageNumber)
        self.imageSelectionHandler = imageSelectionHandler
    }
}
