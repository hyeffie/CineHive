//
//  BaseViewController.swift
//  CineHive
//
//  Created by Effie on 1/24/25.
//

import UIKit

class BaseViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    private func configureView() {
        self.view.backgroundColor = CHColor.mainBackground
    }
    
    func push(_ viewController: UIViewController) {
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func pop() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func replaceWindowRoot(to newViewController: UIViewController) {
        guard
            let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
            let window = windowScene.windows.first
        else {
            return
        }
        window.rootViewController = newViewController
    }
}
