import Foundation

protocol CartViewControllerProtocol: AnyObject {
    func updateCartElements()
    func setLoaderIsHidden(_ isHidden: Bool)
    func showCartAlert(with error: String)
}
