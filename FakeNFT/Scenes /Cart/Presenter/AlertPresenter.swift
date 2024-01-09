import UIKit

final class AlertPresenter: AlertPresenterProtocol {
    weak var delegate: UIViewController?
    
    init(delegate: UIViewController) {
        self.delegate = delegate
    }
    
    func showAlert(with model: AlertModel) {
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
