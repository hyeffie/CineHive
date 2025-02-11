//
//  ProfileInfoView.swift
//  CineHive
//
//  Created by Effie on 1/28/25.
//

import UIKit

final class ProfileInfoView: UIView {
    private let viewModel: ProfileInfoViewModel
    
    private let tapHandler: (() -> ())?
    
    private let profileImageView = ProfileImageView(isSelected: true)
    
    private let nicknameLabel = {
        let label = BaseLabel(font: CHFont.largeBold)
        label.text = "달콤한 기모청바지"
        return label
    }()
    
    private let createdAtLabel = {
        let label = BaseLabel(font: CHFont.medium)
        label.text = "25.01.24 가입"
        return label
    }()
    
    private let chevron = {
        let imageView = UIImageView()
        let symbolConfiguration = UIImage.SymbolConfiguration(pointSize: 16, weight: .semibold, scale: .large)
        imageView.image = UIImage(systemName: "chevron.right")?.applyingSymbolConfiguration(symbolConfiguration)
        imageView.tintColor = CHColor.lightLabelBackground
        return imageView
    }()
    
    private let movieBoxLabel = {
        let label = BaseLabel(font: CHFont.largeBold, alignment: .center)
        label.text = "00 개의 무비박스 보관중"
        label.backgroundColor = CHColor.theme
        label.configureRadius(to: 10)
        return label
    }()
    
    init(
        viewModel: ProfileInfoViewModel,
        tapHandler: (() -> ())?
    ) {
        self.viewModel = viewModel
        self.tapHandler = tapHandler
        super.init(frame: .zero)
        bind()
        configureViews()
        self.viewModel.input.initialized.value = ()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        self.tapHandler?()
    }
    
    private func bind() {
        self.viewModel.output.profileImageName.lazyBind { [weak self] imageName in
            guard let imageName else { return }
            self?.profileImageView.configureImage(name: imageName)
        }
        
        self.viewModel.output.nicknameLabelText.lazyBind { [weak self] nickname in
            self?.nicknameLabel.text = nickname
        }
        
        self.viewModel.output.createdAtLabelText.lazyBind { [weak self] createdAt in
            self?.createdAtLabel.text = createdAt
        }
        
        self.viewModel.output.movieBoxLabelText.lazyBind { [weak self] movieBoaLabelText in
            self?.movieBoxLabel.text = movieBoaLabelText
        }
    }
    
    private func configureViews() {
        let outerInset: CGFloat = 16
        let defaultSpacing: CGFloat = 10
        
        self.addSubview(self.profileImageView)
        self.profileImageView.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().offset(outerInset)
            make.height.equalToSuperview().multipliedBy(0.35)
            make.width.equalTo(self.profileImageView.snp.height)
        }
        
        let stack = UIStackView(arrangedSubviews: [self.nicknameLabel, self.createdAtLabel])
        stack.axis = .vertical
        stack.spacing = 6
        stack.alignment = .leading
        
        self.addSubview(stack)
        stack.snp.makeConstraints { make in
            make.centerY.equalTo(self.profileImageView)
            make.leading.equalTo(self.profileImageView.snp.trailing).offset(defaultSpacing)
        }
        
        self.addSubview(self.chevron)
        self.chevron.snp.makeConstraints { make in
            make.centerY.equalTo(self.profileImageView)
            make.leading.equalTo(stack.snp.trailing).offset(defaultSpacing)
            make.trailing.equalToSuperview().offset(-1 * outerInset)
        }
        
        self.addSubview(self.movieBoxLabel)
        self.movieBoxLabel.snp.makeConstraints { make in
            make.top.equalTo(self.profileImageView.snp.bottom).offset(outerInset)
            make.horizontalEdges.bottom.equalToSuperview().inset(outerInset)
        }
        
        self.backgroundColor = CHColor.darkLabelBackground.withAlphaComponent(0.5)
        self.layer.cornerRadius = 20
        self.isUserInteractionEnabled = true
    }
}
