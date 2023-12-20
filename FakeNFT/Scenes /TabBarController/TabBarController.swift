import UIKit

final class TabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBar.unselectedItemTintColor = UIColor.NFTColor.black
        view.backgroundColor = .systemBackground
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let profileViewController = UINavigationController(rootViewController: ProfileViewController())
        let catalogViewController = UINavigationController(rootViewController: CatalogViewController())
        let cartViewController = UINavigationController(rootViewController: CartViewController())
        let statisticsViewController = UINavigationController(rootViewController: StatisticsViewController())
        
        profileViewController.tabBarItem = UITabBarItem(title: "Профиль", image: ImageAssets.profileTabBarOff, selectedImage: ImageAssets.profileTabBarOn)
        catalogViewController.tabBarItem = UITabBarItem(title: "Каталог", image: ImageAssets.catalogTabBarOff, selectedImage: ImageAssets.catalogTabBarOn)
        cartViewController.tabBarItem = UITabBarItem(title: "Корзина", image: ImageAssets.cartTabBarOff, selectedImage: ImageAssets.cartTabBarOn)
        statisticsViewController.tabBarItem = UITabBarItem(title: "Статистика", image: ImageAssets.statisticsTabBarOff, selectedImage: ImageAssets.statisticsTabBarOn)
        
        self.viewControllers = [profileViewController, catalogViewController, cartViewController, statisticsViewController]
    }
}
