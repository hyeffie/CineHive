//
//  ProfileInfoView.swift
//  CineHive
//
//  Created by Effie on 1/28/25.
//

import UIKit

final class ProfileInfoView: UIView {
    @UserDefault(key: UserDefaultKey.userProfile)
    private var profileInfo: ProfileInfo!
    
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
    
    init(tapHandler: (() -> ())?) {
        self.tapHandler = tapHandler
        super.init(frame: .zero)
        addNotificationObserver()
        configureViews()
        configureInfo()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        self.tapHandler?()
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
    
    @objc private func configureInfo() {
        let imageName = CHImageName.profileImage(number: self.profileInfo.imageNumber)
        self.profileImageView.configureImage(name: imageName)
        
        self.nicknameLabel.text = self.profileInfo.nickname
        
        let dateEncoder = DateFormatter()
        dateEncoder.dateFormat = "yy.MM.dd"
        self.createdAtLabel.text = "\(dateEncoder.string(from: self.profileInfo.createdAt)) 가입"
        self.movieBoxLabel.text = "\(self.profileInfo.likedMovieIDs.count) 개의 무비박스 보관중"
    }
    
    private func addNotificationObserver() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.configureInfo),
            name: CHNotification.userProfileUpdated,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.configureInfo),
            name: CHNotification.userLikedMovieMutated,
            object: nil
        )
    }
}
