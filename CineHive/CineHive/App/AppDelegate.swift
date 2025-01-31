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
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.rootViewController = viewController()
        self.window?.makeKeyAndVisible()
        return true
    }
    
    private func viewController() -> UIViewController {
//        if self.userProfile == nil {
//            let viewController = OnboardingViewController()
//            return NavigationController(rootViewController: viewController)
//        } else {
//            return TabBarController()
//        }
        
        let detail = MovieDetail.init(id: 12, title: "하얼빈", releaseDate: "2025-01-01", voteAverage: 4.5, genreIDS: [28, 16, 80],
                     overview: "Alamofire builds on Linux, Windows, and Android but there are missing features and many issues in the underlying swift-corelibs-foundation that prevent full functionality and may cause crashes. These include:",
                     liked: true)
        let vc = MovieDetailViewController(movieDetail: detail)
        return NavigationController(rootViewController: vc)
    }
}
