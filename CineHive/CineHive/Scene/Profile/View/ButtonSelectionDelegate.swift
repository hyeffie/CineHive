//
//  ButtonSelectionDelegate.swift
//  CineHive
//
//  Created by Effie on 2/10/25.
//

import UIKit

protocol ButtonSelectionDelegate: AnyObject {
    func didSelect(_ selected: SelectableView)
    func didDeselect(_ deselected: SelectableView)
}
