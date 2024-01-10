import Foundation

protocol AlertPresenterProtocol: AnyObject {
    func showCartAlert(with model: CartAlertModel)
}
