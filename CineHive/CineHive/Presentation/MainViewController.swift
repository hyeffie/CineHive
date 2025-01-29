//
//  MainViewController.swift
//  CineHive
//
//  Created by Effie on 1/30/25.
//

import UIKit

final class MainViewController: BaseViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
    }
    
    private func configureViews() {
        self.title = "CineHive"
    }
}
