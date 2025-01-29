//
//  ProfileInfoView.swift
//  CineHive
//
//  Created by Effie on 1/28/25.
//

import UIKit

final class ProfileInfoView: UIView {
    private let profileInfo: ProfileInfo
    
    private let profileImageView = ProfileImageView(imageName: nil, isSelected: true)
    
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
        label.text = "00개의 무비박스 보관중"
        label.backgroundColor = CHColor.theme
        label.configureRadius(to: 10)
        return label
    }()
    
    init(profileInfo: ProfileInfo) {
        self.profileInfo = profileInfo
        super.init(frame: .zero)
        configureViews()
        configureInfo()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
    }
    
    private func configureInfo() {
        let imageName = CHImageName.profileImage(number: self.profileInfo.imageNumber)
        self.profileImageView.configureImage(name: imageName)
        
        self.nicknameLabel.text = self.profileInfo.nickname
        
        let dateEncoder = DateFormatter()
        dateEncoder.dateFormat = "yy.MM.dd"
        self.createdAtLabel.text = "\(dateEncoder.string(from: self.profileInfo.createdAt)) 가입"
        self.movieBoxLabel.text = "\(self.profileInfo.likedMovieIDs.count)개의 무비박스 보관중"
    }
}

struct ProfileInfo {
    let imageNumber: Int
    let nickname: String
    let createdAt: Date
    let likedMovieIDs: [String]
    
    init(
        imageNumber: Int,
        nickname: String,
        createdAt: Date,
        likedMovieIDs: [String]
    ) {
        self.imageNumber = imageNumber
        self.nickname = nickname
        self.createdAt = createdAt
        self.likedMovieIDs = likedMovieIDs
    }
    
    init(nickname: String) {
        self.imageNumber = (0..<12).randomElement() ?? 0
        self.nickname = nickname
        self.createdAt = Date()
        self.likedMovieIDs = []
    }
}

final class TempVC: BaseViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureViews()
    }
    
    private let infoView = ProfileInfoView(profileInfo: .init(nickname: "에피"))
    
    private func configureViews() {
        self.view.addSubview(self.infoView)
        self.infoView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(self.view.safeAreaLayoutGuide).inset(10)
            make.height.equalTo(self.view.safeAreaLayoutGuide).multipliedBy(0.26)
        }
    }
}

#Preview {
    TempVC()
}
