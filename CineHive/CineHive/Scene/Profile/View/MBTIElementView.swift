//
//  MBTIElementView.swift
//  CineHive
//
//  Created by Effie on 2/10/25.
//

import UIKit

struct MBTI {
    protocol Element: CaseIterable { }
    
    enum EI: String, Element {
        case e = "E"
        case i = "I"
    }
    
    enum NS: String, Element {
        case n = "N"
        case s = "S"
    }
    
    enum TF: String, Element {
        case t = "T"
        case f = "F"
    }
    
    enum PJ: String, Element {
        case p = "P"
        case j = "J"
    }
    
    var ei: EI
    var ns: NS
    var tf: TF
    var pj: PJ
}

protocol SelectionDelegate: AnyObject {
    func didSelect(_ selected: UIControl)
    func didDeselect(_ deselected: UIControl)
}

final class CharacterButton: UIButton {
    private weak var selectionDelegate: (any SelectionDelegate)?
    
    init(
        character: Character,
        selectionDelegate: any SelectionDelegate
    ) {
        super.init(frame: .zero)
        configureView(title: "\(character)")
        addEventHandler()
    }
    
    override var isSelected: Bool {
        didSet {
            if self.isSelected {
                self.selectionDelegate?.didSelect(self)
            } else {
                self.selectionDelegate?.didDeselect(self)
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureView(title: String) {
        self.snp.makeConstraints { make in
            make.size.equalTo(44)
        }
        
        var configuration = UIButton.Configuration.bordered()
        
        var attributeContainer = AttributeContainer()
        attributeContainer.font = CHFont.largeBold
        configuration.cornerStyle = .capsule
        configuration.background.strokeColor = CHColor.lightLabelBackground
        
        self.configuration = configuration
        
        self.configurationUpdateHandler = { button in
            var attributeContainer = AttributeContainer()
            attributeContainer.font = CHFont.large
            switch button.state {
            case .normal:
                attributeContainer.foregroundColor = CHColor.lightLabelBackground
                
                button.configuration?.background.strokeWidth = 2
                button.configuration?.background.backgroundColor = .clear
            case .selected:
                attributeContainer.foregroundColor = CHColor.primaryText
                button.configuration?.background.strokeWidth = 0
                button.configuration?.background.backgroundColor = CHColor.validCompleteButton
            default:
                return
            }
            button.configuration?.attributedTitle = AttributedString(title, attributes: attributeContainer)
        }
    }
    
    private func addEventHandler() {
        self.addTarget(self, action: #selector(toggle), for: .touchUpInside)
    }
    
    @objc private func toggle() {
        self.isSelected.toggle()
    }
}
