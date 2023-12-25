//
//  SortAlertPresenter.swift
//  FakeNFT
//
//  Created by Ян Максимов on 14.12.2023.
//

import UIKit

struct AlertModel {
    var alertControllerStyle: UIAlertController.Style
    var alertTitle: String
    var alertMessage: String?
    var alertActions: [UIAlertAction]
}

final class AlertPresenter {
    
    weak var presentingViewController: UIViewController?
    
    init(delegate: UIViewController? = nil) {
        self.presentingViewController = delegate
    }
    
    // MARK: Present Alert
    func presentAlert(result: AlertModel) {
        let alert = UIAlertController(title: result.alertTitle, message: result.alertMessage, preferredStyle: result.alertControllerStyle)
        addActionItems(result.alertActions, to: alert)
        displayAlert(alert)
    }
    
    // MARK: Add Action Items
    private func addActionItems(_ actions: [UIAlertAction], to alert: UIAlertController) {
        for action in actions {
            alert.addAction(action)
        }
    }
    
    // MARK: Display Alert
    private func displayAlert(_ alert: UIAlertController) {
        presentingViewController?.present(alert, animated: true, completion: nil)
    }
}
