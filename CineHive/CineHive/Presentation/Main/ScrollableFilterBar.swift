//
//  ScrollableFilterBar.swift
//  CineHive
//
//  Created by Effie on 1/31/25.
//

import UIKit

final class ScrollableFilterBar: UIScrollView {
    private let stackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .center
        return stack
    }()
    
    private var selectedIndex: Int? = nil
    
    weak var scrollableFilterBarDelegate: ScrollableFilterBarDelegate?
    
    /// 내부 view 간의 spacing을 설정할 수 있는 생성자입니다.
    /// - Parameter spacing: 내부 view 간의 spacing
    ///
    /// superview의  height 를  반드시 고정해야 합니다.
    init(spacing: CGFloat, trailingContentInset: CGFloat = 0) {
        super.init(frame: .zero)
        configureScrollView(trailingInset: trailingContentInset)
        setViews(spacing: spacing)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureScrollView(trailingInset: CGFloat) {
        self.showsVerticalScrollIndicator = false
        self.showsHorizontalScrollIndicator = false
        self.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: trailingInset)
    }

    private func setViews(spacing: CGFloat) {
        self.addSubview(self.stackView)
        self.stackView.snp.makeConstraints { make in
            make.edges.height.equalToSuperview()
        }
        self.stackView.spacing = spacing
        
        self.stackView.arrangedSubviews.forEach { view in
            view.layoutIfNeeded()
        }
    }
}

extension ScrollableFilterBar: SelectableViewHandlable {
    func addSelectables(selectableViews: [SelectableView]) {
        selectableViews.forEach { self.stackView.addArrangedSubview($0)}
    }
    
    func handleSelection(of selectedView: any SelectableView) {
        for (index, view) in self.stackView.arrangedSubviews.enumerated() {
            guard let selectableView = view as? SelectableView else { return }
            if selectableView === selectedView {
                if index == self.selectedIndex {
                    self.selectedIndex = nil
                    selectedView.deselect()
                    self.scrollableFilterBarDelegate?.scrollableFilterBarCancelSelection()
                } else {
                    self.selectedIndex = index
                    selectedView.select()
                    self.scrollableFilterBarDelegate?.scrollableFilterBar(didSelectItemAt: index)
                }
            } else {
                selectableView.deselect()
            }
        }
    }
}

protocol ScrollableFilterBarDelegate: AnyObject {
    func scrollableFilterBar(didSelectItemAt index: Int)
    func scrollableFilterBarCancelSelection()
}
