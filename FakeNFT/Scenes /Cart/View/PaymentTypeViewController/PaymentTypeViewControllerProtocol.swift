import Foundation

protocol PaymentTypeViewControllerProtocol: AnyObject {
    func collectionViewUpdate()
    func setLoaderIsHidden(_ isHidden: Bool)
    func showPaymentAlert(with error: String)
}
