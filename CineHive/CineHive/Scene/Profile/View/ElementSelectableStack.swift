//
//  ElementSelectableStack.swift
//  CineHive
//
//  Created by Effie on 2/10/25.
//

import UIKit

protocol ElementSelectableStackDelegate: AnyObject {
    func didSelectControl(at index: Int)
    func didDeselecControl(at index: Int)
}

final class ElementSelectableStack: UIStackView {
    private(set) var selectedIndex: Int? = nil
    
    private weak var delegate: ElementSelectableStackDelegate?
    
    private var controls: [UIControl] {
        return self.arrangedSubviews.compactMap { view in view as? UIControl }
    }
    
    init(
        delegate: ElementSelectableStackDelegate,
        axis: NSLayoutConstraint.Axis,
        spacing: CGFloat
    ) {
        self.delegate = delegate
        super.init(frame: .zero)
        configureStack(axis: axis, spacing: spacing)
    }
    
    @available(*, unavailable)
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureStack(
        axis: NSLayoutConstraint.Axis,
        spacing: CGFloat
    ) {
        self.axis = axis
        self.spacing = spacing
    }
    
    func addControls(_ controls: [UIControl]) {
        self.arrangedSubviews.forEach { view in
            view.removeFromSuperview()
        }
        
        controls.forEach { control in
            self.addArrangedSubview(control)
        }
    }
    
    func selectIndex(at selectedIndex: Int) {
        self.controls.enumerated().forEach { (index, control) in
            control.isSelected = index == selectedIndex
        }
        self.selectedIndex = selectedIndex
    }
}


extension ElementSelectableStack: SelectionDelegate {
    func didSelect(_ selected: UIControl) {
        self.controls.enumerated().forEach { (index, control) in
            if control === selected {
                self.selectedIndex = index
                self.delegate?.didSelectControl(at: index)
            } else {
                control.isSelected = false
            }
        }
    }
    
    func didDeselect(_ deselected: UIControl) {
        guard let index = self.selectedIndex else { return }
        self.delegate?.didDeselecControl(at: index)
        self.selectedIndex = nil
    }
}
