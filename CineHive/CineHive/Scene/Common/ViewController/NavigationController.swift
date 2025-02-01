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
        self.navigationItem.backButtonTitle = " "
        
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = CHColor.mainBackground
        appearance.titleTextAttributes = [
            .foregroundColor: CHColor.primaryText,
        ]
        self.navigationBar.standardAppearance = appearance
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        super.pushViewController(viewController, animated: animated)
    }
    
    override func popViewController(animated: Bool) -> UIViewController? {
        let poppedViewController = super.popViewController(animated: animated)
        return poppedViewController
    }
}
