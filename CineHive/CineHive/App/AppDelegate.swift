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
    
    @UserDefault(key: UserDefaultKey.userProfile)
    private var userProfile: ProfileInfo?
}

extension AppDelegate: UIApplicationDelegate {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        configureGlobalAppearance()
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.rootViewController = viewController()
        self.window?.makeKeyAndVisible()
        delayTransition()
        return true
    }
    
    private func delayTransition() {
        Thread.sleep(forTimeInterval: 2.0)
    }
    
    private func viewController() -> UIViewController {
        if self.userProfile == nil {
            let viewController = OnboardingViewController()
            return NavigationController(rootViewController: viewController)
        } else {
            return TabBarController()
        }
    }
    
    private func configureGlobalAppearance() {
        let appearance = UITextField.appearance()
        appearance.backgroundColor = CHColor.darkLabelBackground.withAlphaComponent(0.3)
        appearance.textColor = CHColor.primaryText
        appearance.tintColor = CHColor.primaryText
        appearance.keyboardAppearance = .dark
        appearance.borderStyle = .roundedRect
    }
}
