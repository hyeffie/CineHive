//
//  OnboardingViewController.swift
//  CineHive
//
//  Created by Effie on 1/24/25.
//

import UIKit
import SnapKit

final class OnboardingViewController: BaseViewController {
    private let imageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let titleLabel = BaseLabel(font: .largeBold, alignment: .center)
    
    private let subtitleLabel = BaseLabel(font: .large, alignment: .center)
    
    private let startButton = ThemePillShapeButton(title: "시작하기")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    private func configureView() {
        self.view.addSubview(self.imageView)
        self.imageView.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(self.view)
            make.centerY.equalTo(self.view.safeAreaLayoutGuide).offset(-100)
            make.height.equalTo(self.view.safeAreaLayoutGuide).multipliedBy(0.6)
        }
        
        self.view.addSubview(self.titleLabel)
        self.titleLabel.snp.makeConstraints { make in
            make.top.equalTo(self.imageView.snp.bottom)
            make.centerX.equalToSuperview()
        }
        
        self.view.addSubview(self.subtitleLabel)
        self.subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(self.titleLabel.snp.bottom).offset(24)
            make.centerX.equalToSuperview()
        }
        
        self.view.addSubview(self.startButton)
        self.startButton.snp.makeConstraints { make in
            make.top.equalTo(self.subtitleLabel.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(self.view.safeAreaLayoutGuide).inset(20)
        }
        
        self.imageView.image = UIImage(named: CHImageName.onboarding)
        self.titleLabel.text = "Onboarding"
        self.subtitleLabel.text = "당신만의 영화 세상,\nCineHive를 시작해보세요."
        
        self.startButton.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
    }
    
    @objc private func startButtonTapped() {
        print(#function)
    }
}
