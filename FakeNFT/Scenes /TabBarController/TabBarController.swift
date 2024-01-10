import UIKit

final class TabBarController: UITabBarController {

    var servicesAssembly: ServicesAssembly!

    override func viewDidLoad() {
        super.viewDidLoad()

        tabBar.unselectedItemTintColor = .nftBlack
        view.backgroundColor = .systemBackground
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        let catalogPresenter = CatalogPresenter()

        let profileVC = ProfileViewController()
        let catalogVC = CatalogViewController(presenter: catalogPresenter)
        let cartVC = CartViewController(
//            catalog: catalogVC
        )
        let statisticsVC = StatisticsViewController()

        let profileViewController = UINavigationController(rootViewController: profileVC)
        let catalogViewController = UINavigationController(rootViewController: catalogVC)
        let cartViewController = UINavigationController(rootViewController: cartVC)
        let statisticsViewController = UINavigationController(rootViewController: statisticsVC)

        profileViewController.tabBarItem = UITabBarItem(title: LocalizedStrings.profileTabBarText,
                                                        image: TabBarImageAssets.profileTabBarOff,
                                                        selectedImage: TabBarImageAssets.profileTabBarOn)
        catalogViewController.tabBarItem = UITabBarItem(title: LocalizedStrings.catalogTabBarText,
                                                        image: TabBarImageAssets.catalogTabBarOff,
                                                        selectedImage: TabBarImageAssets.catalogTabBarOn)
        cartViewController.tabBarItem = UITabBarItem(title: LocalizedStrings.cartTabBarText,
                                                     image: TabBarImageAssets.cartTabBarOff,
                                                     selectedImage: TabBarImageAssets.cartTabBarOn)
        statisticsViewController.tabBarItem = UITabBarItem(title: LocalizedStrings.statisticsTabBarText,
                                                           image: TabBarImageAssets.statisticsTabBarOff,
                                                           selectedImage: TabBarImageAssets.statisticsTabBarOn)

        self.viewControllers = [profileViewController,
                                catalogViewController,
                                cartViewController,
                                statisticsViewController]
    }
}
