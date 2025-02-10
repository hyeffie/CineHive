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
    
    private var selectables: [SelectableView] {
        return self.arrangedSubviews.compactMap { view in view as? SelectableView }
    }
    
    init(
        delegate: ElementSelectableStackDelegate,
        axis: NSLayoutConstraint.Axis = .vertical,
        spacing: CGFloat = 8
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
        self.selectables.enumerated().forEach { (index, control) in
            if index == selectedIndex {
                control.select()
            } else {
                control.deselect()
            }
        }
        self.selectedIndex = selectedIndex
    }
}


extension ElementSelectableStack: ButtonSelectionDelegate {
    func shouldSelect(_ selected: SelectableView) {
        self.selectables.enumerated().forEach { (index, control) in
            if control === selected {
                self.selectedIndex = index
                control.select()
                self.delegate?.didSelectControl(at: index)
            } else {
                control.deselect()
            }
        }
    }
    
    func shouldDeSelect(_ deselected: SelectableView) {
        deselected.deselect()
        self.selectedIndex = nil
        guard let index = self.selectables.firstIndex(where: { selectable in selectable === deselected }) else { return }
        self.delegate?.didDeselecControl(at: index)
    }
}
