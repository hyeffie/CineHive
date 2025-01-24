//
//  NavigationController.swift
//  CineHive
//
//  Created by Effie on 1/24/25.
//

import UIKit

final class NavigationController: UINavigationController {
    private lazy var priorViewControllerTitle: String? = self.topViewController?.title
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    private func configureView() {
        self.view.backgroundColor = CHColor.mainBackground.value
        configureBar()
    }
    
    private func configureBar() {
        self.navigationBar.titleTextAttributes = [
            .foregroundColor: CHColor.primaryText,
            .font: CHFont.largeBold
        ]
        self.navigationBar.tintColor = CHColor.theme.value
        self.navigationItem.backButtonTitle = ""
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        self.priorViewControllerTitle = self.topViewController?.title
        self.topViewController?.title = ""
        super.pushViewController(viewController, animated: animated)
    }
    
    override func popViewController(animated: Bool) -> UIViewController? {
        let poppedViewController = super.popViewController(animated: animated)
        self.topViewController?.title = self.priorViewControllerTitle
        return poppedViewController
    }
}
