//import UIKit
//
//final class TabBarController: UITabBarController {
//
//    var servicesAssembly: ServicesAssembly!
//
//    private let catalogTabBarItem = UITabBarItem(
//        title: NSLocalizedString("Tab.catalog", comment: ""),
//        image: UIImage(systemName: "square.stack.3d.up.fill"),
//        tag: 0
//    )
//
//    private let statisticsTabBarItem = UITabBarItem(
//        title: NSLocalizedString("Statistics", comment: ""),
//        image: UIImage(systemName: "flag.2.crossed.fill"),
//        tag: 1
//    )
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        let catalogController = TestCatalogViewController(
//            servicesAssembly: servicesAssembly
//        )
//        catalogController.tabBarItem = catalogTabBarItem
//
//        let statisticsController = StatisticsViewController()
//        statisticsController.tabBarItem = statisticsTabBarItem
//
//        viewControllers = [catalogController, statisticsController]
//
//        view.backgroundColor = .systemBackground
//    }
//
////    override func viewDidLoad() {
////            super.viewDidLoad()
////
////            tabBar.unselectedItemTintColor = .NFTBlack
////            view.backgroundColor = .systemBackground
////        }
////
////    override func viewWillAppear(_ animated: Bool) {
////        super.viewWillAppear(animated)
////
////        let catalogViewController = UINavigationController(rootViewController: TestCatalogViewController())
////        let statisticsViewController = UINavigationController(rootViewController: StatisticsViewController())
////
////
////        catalogViewController.tabBarItem = UITabBarItem(title: "Каталог", image: ImageKeys.catalogTabBarOff, selectedImage: ImageKeys.catalogTabBarOn)
////
////        statisticsViewController.tabBarItem = UITabBarItem(title: "Статистика", image: ImageKeys.statisticsTabBarOff, selectedImage: ImageKeys.statisticsTabBarOn)
////
////        self.viewControllers = [catalogViewController, statisticsViewController]
////    }
//}

import UIKit

final class TabBarController: UITabBarController {

    var servicesAssembly: ServicesAssembly!

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground

        let catalogViewController = UINavigationController(rootViewController: TestCatalogViewController(servicesAssembly: servicesAssembly))
        catalogViewController.tabBarItem = UITabBarItem(title: NSLocalizedString("Tab.catalog", comment: ""), image: UIImage(systemName: "square.stack.3d.up.fill"), tag: 0)

        let statisticsViewController = UINavigationController(rootViewController: StatisticsViewController())
        statisticsViewController.tabBarItem = UITabBarItem(title: NSLocalizedString("Statistics", comment: ""), image: UIImage(systemName: "flag.2.crossed.fill"), tag: 1)

        self.viewControllers = [catalogViewController, statisticsViewController]
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if let viewControllers = self.viewControllers {
            for viewController in viewControllers {
                if let navigationController = viewController as? UINavigationController,
                   let rootViewController = navigationController.topViewController {
                    rootViewController.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
                }
            }
        }
    }
}

