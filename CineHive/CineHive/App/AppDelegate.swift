//
//  AppDelegate.swift
//  CineHive
//
//  Created by Effie on 1/24/25.
//

import UIKit

@main
final class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.rootViewController = viewController()
        self.window?.makeKeyAndVisible()
        return true
    }
    
    private func viewController() -> UIViewController {
        return NavigationController(rootViewController: viewController)
    }
}
