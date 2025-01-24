//
//  NavigationController.swift
//  CineHive
//
//  Created by Effie on 1/24/25.
//

import UIKit

final class NavigationController: UINavigationController {
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    private func configureView() {
        self.view.backgroundColor = CHColor.mainBackground
        configureBar()
    }
    
    private func configureBar() {
        self.navigationBar.titleTextAttributes = [
            .foregroundColor: CHColor.primaryText,
            .font: CHFont.largeBold
        ]
        self.navigationBar.tintColor = CHColor.theme
        self.navigationItem.backButtonTitle = ""
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        self.topViewController?.title = ""
        super.pushViewController(viewController, animated: animated)
    }
}
