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
