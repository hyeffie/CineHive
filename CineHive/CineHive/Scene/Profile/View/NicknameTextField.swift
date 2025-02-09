//
//  NicknameTextField.swift
//  CineHive
//
//  Created by Effie on 1/24/25.
//

import UIKit

final class NicknameTextField: UIView {
    var input: String {
        return self.field.text ?? ""
    }
    
    private let field = {
        let field = UITextField()
        field.borderStyle = .none
        field.textColor = CHColor.primaryText
        field.font = CHFont.medium
        field.backgroundColor = .clear
        return field
    }()
    
    private let underline = {
        let view = UIView()
        view.backgroundColor = CHColor.primaryText
        return view
    }()
    
    private let validationResultLabel = {
        let label = BaseLabel(color: CHColor.theme, font: CHFont.small)
        label.text = ""
        return label
    }()
    
    private let stack = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .center
        stack.spacing = 16
        return stack
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }
    
    @available(*, unavailable)
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureView() {
        self.addSubview(self.stack)
        self.stack.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        let hInset = 16
        
        self.stack.addArrangedSubview(self.field)
        self.field.snp.makeConstraints { make in
            make.width.equalToSuperview().inset(hInset)
            make.height.equalTo(60)
        }
        
        self.addSubview(self.underline)
        self.underline.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(self.field)
            make.height.equalTo(1)
        }
        
        self.stack.addArrangedSubview(self.validationResultLabel)
        self.validationResultLabel.snp.makeConstraints { make in
            make.width.equalToSuperview().inset(hInset)
            make.height.equalTo(20)
        }
    }
}

extension NicknameTextField {
    func configureValidationResult(message: String) {
        self.validationResultLabel.text = message
    }
    
    func setActionToTextField(
        valueChangeHandler: @escaping (String) -> Void
    ) {
        let action = UIAction { [weak self] _ in
            guard let self else { return }
            let _ = valueChangeHandler(self.input)
        }
        self.field.addAction(action, for: .editingChanged)
    }
    
    func setNickname(_ nickname: String) {
        self.field.text = nickname
    }
}
