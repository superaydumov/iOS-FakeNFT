import UIKit

final class CartAlertPresenter: AlertPresenterProtocol {
    weak var delegate: UIViewController?

    init(delegate: UIViewController) {
        self.delegate = delegate
    }

    func showCartAlert(with model: CartAlertModel) {
        let alert = UIAlertController(title: model.title, message: model.message, preferredStyle: .alert)
        let firstAction = UIAlertAction(title: model.firstButtonText, style: .default) { _ in
            model.firstCompletion()
        }
        let secondAction = UIAlertAction(title: model.secondButtontext, style: .cancel)

        alert.addAction(firstAction)
        alert.addAction(secondAction)

        delegate?.present(alert, animated: true)
    }
}
