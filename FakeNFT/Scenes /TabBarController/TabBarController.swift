import UIKit

final class TabBarController: UITabBarController {
    
    var servicesAssembly: ServicesAssembly!
    
    private let catalogTabBarItem = UITabBarItem(
        title: NSLocalizedString("Tab.catalog", comment: ""),
        image: UIImage(systemName: "square.stack.3d.up.fill"),
        tag: 0
    )
    
    private let profileTabBarItem = UITabBarItem(
        title: "Профиль",
        image: UIImage(named: "profileTabBarActive"), tag: 1)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let profileViewController = UINavigationController(rootViewController: ProfileViewController())
        
        profileViewController.tabBarItem = profileTabBarItem
        
        let catalogController = TestCatalogViewController(
            servicesAssembly: servicesAssembly
        )
        catalogController.tabBarItem = catalogTabBarItem
        
        viewControllers = [profileViewController, catalogController]
        
        view.backgroundColor = .systemBackground
    }
}
