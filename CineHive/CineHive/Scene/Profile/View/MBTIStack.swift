//
//  MBTIStack.swift
//  CineHive
//
//  Created by Effie on 2/10/25.
//

import UIKit

protocol MBTIStackDelegate: AnyObject {
    func didUpdateMBTI(_ mbti: MBTI)
}

final class MBTIStack: UIStackView {
    weak var delegate: MBTIStackDelegate?
    private var mbti: MBTI
    
    private lazy var eiStack: ElementSelectableStack = ElementSelectableStack(delegate: self, axis: .horizontal, spacing: 8)
    private lazy var nsStack: ElementSelectableStack = ElementSelectableStack(delegate: self, axis: .horizontal, spacing: 8)
    private lazy var tfStack: ElementSelectableStack = ElementSelectableStack(delegate: self, axis: .horizontal, spacing: 8)
    private lazy var pjStack: ElementSelectableStack = ElementSelectableStack(delegate: self, axis: .horizontal, spacing: 8)
    
    init(delegate: MBTIStackDelegate) {
        self.delegate = delegate
        self.mbti = MBTI()
        
        super.init(frame: .zero)
        configureStack()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureStack() {
        self.axis = .vertical
        self.spacing = 12
        
        self.addArrangedSubview(eiStack)
        self.addArrangedSubview(nsStack)
        self.addArrangedSubview(tfStack)
        self.addArrangedSubview(pjStack)
        
        setupSelectableStacks()
    }
    
    private func setupSelectableStacks() {
        eiStack.addControls(createButtons(for: MBTI.EI.allCases, stack: eiStack))
        nsStack.addControls(createButtons(for: MBTI.NS.allCases, stack: nsStack))
        tfStack.addControls(createButtons(for: MBTI.TF.allCases, stack: tfStack))
        pjStack.addControls(createButtons(for: MBTI.PJ.allCases, stack: pjStack))
    }
    
    private func createButtons<T: MBTI.Element>(for cases: [T], stack: ElementSelectableStack) -> [CharacterButton] {
        return cases.map { CharacterButton(character: Character($0.character), selectionDelegate: stack) }
    }
    
    func setMBTI(_ mbti: MBTI) {
        self.mbti = mbti
        if let ei = mbti.ei { eiStack.selectIndex(at: MBTI.EI.allCases.firstIndex(of: ei)!) }
        if let ns = mbti.ns { nsStack.selectIndex(at: MBTI.NS.allCases.firstIndex(of: ns)!) }
        if let tf = mbti.tf { tfStack.selectIndex(at: MBTI.TF.allCases.firstIndex(of: tf)!) }
        if let pj = mbti.pj { pjStack.selectIndex(at: MBTI.PJ.allCases.firstIndex(of: pj)!) }
    }
}

extension MBTIStack: ElementSelectableStackDelegate {
    func didSelectControl(at index: Int) {
        updateMBTI()
    }
    
    func didDeselecControl(at index: Int) {
        updateMBTI()
    }
    
    private func updateMBTI() {
        guard let eiIndex = eiStack.selectedIndex,
              let nsIndex = nsStack.selectedIndex,
              let tfIndex = tfStack.selectedIndex,
              let pjIndex = pjStack.selectedIndex else { return }
        
        self.mbti = MBTI(
            ei: MBTI.EI.allCases[eiIndex],
            ns: MBTI.NS.allCases[nsIndex],
            tf: MBTI.TF.allCases[tfIndex],
            pj: MBTI.PJ.allCases[pjIndex]
        )
        
        delegate?.didUpdateMBTI(mbti)
    }
}
