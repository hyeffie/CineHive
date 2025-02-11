//
//  ProfileImageViewModel.swift
//  CineHive
//
//  Created by Effie on 2/9/25.
//

import Foundation

final class ProfileImageViewModel: BaseViewModelProtocol {
    struct Input {
        let viewDidLoad: Observable<Void> = Observable(value: ())
        
        let didSelectCell: Observable<Int?> = Observable(value: nil)
    }
    
    struct Output {
        let navigationTitle: Observable<String> = Observable(value: "")
        
        let imageNumberRange: Observable<Range<Int>> = Observable(value: (0..<12))
        
        let selectedImageNumber: Observable<Int>
        
        let selectedCellIndex: Observable<Int?> = Observable(value: nil)
    }
    
    private(set) var input: Input
    
    private(set) var output: Output
    
    private let imageSelectionHandler: (Int) -> Void
    
    init(
        selectedImageNumber: Int,
        imageSelectionHandler: @escaping (Int) -> Void
    ) {
        self.input = Input()
        self.output = Output(selectedImageNumber: Observable(value: selectedImageNumber))
        self.imageSelectionHandler = imageSelectionHandler
        transform()
    }
    
    func transform() {
        self.input.viewDidLoad.lazyBind { _ in
            self.output.navigationTitle.value = "프로필 이미지 설정"
            self.output.selectedImageNumber.value = self.output.selectedImageNumber.value
            self.output.selectedCellIndex.value = self.output.selectedImageNumber.value
        }
        
        self.input.didSelectCell.lazyBind { selectedCellIndex in
            guard let selectedCellIndex else { return }
            self.output.selectedImageNumber.value = selectedCellIndex
            self.imageSelectionHandler(selectedCellIndex)
        }
    }
}
