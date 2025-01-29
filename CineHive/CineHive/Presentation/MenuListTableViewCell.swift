//
//  MenuListTableViewCell.swift
//  CineHive
//
//  Created by Effie on 1/29/25.
//

import UIKit

final class MenuListTableViewCell: UITableViewCell {
    private let titleLabel = BaseLabel(font: CHFont.medium, alignment: .left)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureViews()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(title: String) {
        self.titleLabel.text = title
    }
    
    private func configureViews() {
        self.contentView.addSubview(self.titleLabel)
        self.titleLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        self.backgroundColor = .clear
    }
}

extension MenuListTableViewCell: ReusableCell { }
