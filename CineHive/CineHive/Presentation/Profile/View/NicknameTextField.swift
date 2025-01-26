//
//  NicknameTextField.swift
//  CineHive
//
//  Created by Effie on 1/24/25.
//

import UIKit

final class NicknameTextField: UITextField {
    private let underline = {
        let view = UIView()
        view.backgroundColor = CHColor.primaryText
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureView() {
        self.addSubview(self.underline)
        self.underline.snp.makeConstraints { make in
            make.horizontalEdges.bottom.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.05)
        }
        
        self.borderStyle = .none
        self.textColor = CHColor.primaryText
        self.backgroundColor = .clear
    }
}
