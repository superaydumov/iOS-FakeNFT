import UIKit

final class TabBarController: UITabBarController {
    
    var servicesAssembly: ServicesAssembly!
    
    private let catalogTabBarItem = UITabBarItem(
        title: "Каталог",
        image: UIImage(systemName: "rectangle.stack.fill"),
        tag: 0
    )
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Создание экземпляра CatalogPresenter
        let catalogPresenter = CatalogPresenter()
        
        // Создание CatalogViewController с передачей CatalogPresenter
        let catalogController = UINavigationController(rootViewController: CatalogViewController(presenter: catalogPresenter))
        
        catalogController.tabBarItem = catalogTabBarItem
        
        viewControllers = [catalogController]
        
        view.backgroundColor = .systemBackground
    }
}
