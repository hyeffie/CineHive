//
//  TabBarController.swift
//  CineHive
//
//  Created by Effie on 1/29/25.
//

import UIKit

final class TabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setViewControllers()
        configure()
    }
    
    private func setViewControllers() {
        let mainFlow = navigationEmebed(
            MainViewController(),
            symbol: CHSymbol.popcorn,
            title: "CINEMA"
        )
        let upcomingFlow = navigationEmebed(
            BaseViewController(),
            symbol: CHSymbol.films,
            title: "UPCOMING"
        )
        let settingFlow = navigationEmebed(
            SettingViewController(),
            symbol: CHSymbol.profile,
            title: "PROFILE"
        )
        
        let controllers: [UIViewController] = [
            mainFlow, upcomingFlow, settingFlow
        ]
        setViewControllers(controllers, animated: false)
    }
    
    private func configure() {
        self.tabBar.tintColor = CHColor.theme
        self.tabBar.unselectedItemTintColor = CHColor.darkLabelBackground
        let appearance = UITabBarAppearance()
        appearance.backgroundColor = CHColor.mainBackground
        self.tabBar.standardAppearance = appearance
    }
    
    private func navigationEmebed(
        _ viewController: UIViewController,
        symbol: CHSymbol,
        title: String
    ) -> UINavigationController {
        let navigationController = NavigationController(rootViewController: viewController)
        navigationController.tabBarItem.image = createStyledImage(systemImage: symbol.value)
        navigationController.tabBarItem.title = title
        return navigationController
    }
    
    private func createStyledImage(systemImage: UIImage?) -> UIImage? {
        let symbolConfig = UIImage.SymbolConfiguration(scale: .large)
        return systemImage?.applyingSymbolConfiguration(symbolConfig)
    }
}
