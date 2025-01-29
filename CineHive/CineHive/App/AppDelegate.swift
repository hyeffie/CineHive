//
//  AppDelegate.swift
//  CineHive
//
//  Created by Effie on 1/24/25.
//

import UIKit

@main
final class AppDelegate: UIResponder {
    var window: UIWindow?
    
    @UserDefault(key: UserDefaultKey.userProfile, defaultValue: nil)
    private var userProfile: ProfileInfo?
}

extension AppDelegate: UIApplicationDelegate {
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
        if self.userProfile == nil {
            let viewController = OnboardingViewController()
            return NavigationController(rootViewController: viewController)
        } else {
            return TabBarController()
        }
    }
}
