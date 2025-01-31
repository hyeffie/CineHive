//
//  ScrollableHStack.swift
//  CineHive
//
//  Created by Effie on 1/31/25.
//

import UIKit

final class ScrollableHStack: UIScrollView {
    private let stackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .center
        return stack
    }()
    
    private var selectedIndex: Int? = nil
    
    /// 내부 view 간의 spacing을 설정할 수 있는 생성자입니다.
    /// - Parameter spacing: 내부 view 간의 spacing
    ///
    /// superview의  height 를  반드시 고정해야 합니다.
    init(spacing: CGFloat, horizontalContentInset: CGFloat = 0) {
        super.init(frame: .zero)
        configureScrollView(horizontalContentInset: horizontalContentInset)
        configureViews(spacing: spacing)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureScrollView(horizontalContentInset: CGFloat) {
        self.showsVerticalScrollIndicator = false
        self.showsHorizontalScrollIndicator = false
        self.contentInset = UIEdgeInsets(top: 0, left: horizontalContentInset, bottom: 0, right: horizontalContentInset)
    }

    private func configureViews(spacing: CGFloat) {
        self.addSubview(self.stackView)
        self.stackView.snp.makeConstraints { make in
            make.edges.height.equalToSuperview()
        }
        self.stackView.spacing = spacing
        
        self.stackView.arrangedSubviews.forEach { view in
            view.layoutIfNeeded()
        }
    }
    
    func addViews(_ views: [UIView]) {
        self.stackView.removeAllArrangedSubviews()
        views.forEach { self.stackView.addArrangedSubview($0)}
    }
    
    func removeAllViews() {
        self.stackView.removeAllArrangedSubviews()
    }
}
