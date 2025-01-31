//
//  SelectableView.swift
//  CineHive
//
//  Created by Effie on 1/31/25.
//

import UIKit

protocol SelectableView: UIView {
    func select()
    func deselect()
}

protocol SelectableViewHandlable: AnyObject {
    func handleSelection(of selectedView: SelectableView)
}
