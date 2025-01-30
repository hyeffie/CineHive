//
//  SectionedView.swift
//  CineHive
//
//  Created by Effie on 1/30/25.
//

import UIKit

final class SectionedView<Content: UIView>: UIView {
    private let titleLabel = BaseLabel(font: CHFont.largeBold)
    
    private let button: UIButton?
    
    let content: Content
    
    init(
        title: String,
        accessoryButtonInfo: (title: String, action: () -> ())? = nil,
        content: Content
    ) {
        if let accessoryButtonInfo {
            let action = UIAction(handler: { _ in accessoryButtonInfo.action() })
            self.button = UIButton(primaryAction: action)
            self.button?.setTitle(accessoryButtonInfo.title, for: .normal)
        } else {
            self.button = nil
        }
        
        self.content = content
        super.init(frame: .zero)
        self.titleLabel.text = title
        configreViews()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configreViews() {
        let titleStack = UIStackView(arrangedSubviews: [self.titleLabel])
        titleStack.axis = .horizontal
        titleStack.alignment = .center
        
        if let button {
            titleStack.addArrangedSubview(button)
            button.titleLabel?.font = CHFont.medium
            button.setTitleColor(CHColor.theme, for: .normal)
            button.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        }
        
        let titleContainer = UIView()
        titleContainer.addSubview(titleStack)
        titleStack.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(16)
            make.verticalEdges.equalToSuperview()
        }
        
        let containerStack = UIStackView(arrangedSubviews: [titleContainer])
        containerStack.axis = .vertical
        containerStack.alignment = .fill
        containerStack.spacing = 12
        
        containerStack.addArrangedSubview(self.content)
        
        self.addSubview(containerStack)
        containerStack.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

class TempViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .black
        configureView()
    }
    
    func configureView() {
        let content = UIView()
        // content size를 조절하거나
        content.snp.makeConstraints { make in
            make.height.equalTo(100)
        }
        
        content.backgroundColor = .red
        
        let target = SectionedView(
            title: "오늘의 추천 영화",
            accessoryButtonInfo: ("펼치기", { print("TAP") }),
            content: content
        )
        
        self.view.addSubview(target)
        target.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(self.view.safeAreaLayoutGuide)
            make.centerY.equalTo(self.view.safeAreaLayoutGuide)
        }
        
        // container size를 조절
//        target.snp.makeConstraints { make in
//            make.height.equalTo(self.view.safeAreaLayoutGuide).multipliedBy(0.5)
//        }
    }
}

#Preview {
    TempViewController()
}
