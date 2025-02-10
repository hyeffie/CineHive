//
//  ButtonSelectionDelegate.swift
//  CineHive
//
//  Created by Effie on 2/10/25.
//

import UIKit

protocol ButtonSelectionDelegate: AnyObject {
    func shouldSelect(_ selected: SelectableView)
    func shouldDeSelect(_ deselected: SelectableView)
}
