//
//  AlertFactory.swift
//  FakeNFT
//
//  Created by Ян Максимов on 07.01.2024.
//

import UIKit

class AlertFactory {
    
    static let shared = AlertFactory()
    
    private init() {}
    
    func showActionSheet(from viewController: UIViewController,
                         title: String?,
                         message: String?,
                         actions: [UIAlertAction],
                         cancelTitle: String = "Отмена"
    ) {
        let actionSheetController = UIAlertController(title: title,
                                                      message: message,
                                                      preferredStyle: .actionSheet)
        actions.forEach { actionSheetController.addAction($0) }
        let cancelAction = UIAlertAction(title: cancelTitle, style: .cancel)
        actionSheetController.addAction(cancelAction)
        viewController.present(actionSheetController, animated: true)
    }
    
    // Функция для создания и отображения UIAlertController
    func showAlert(from viewController: UIViewController,
                   title: String,
                   message: String?,
                   actions: [UIAlertAction]
    ) {
        let alertController = UIAlertController(title: title,
                                                message: message,
                                                preferredStyle: .alert)
        actions.forEach { alertController.addAction($0) }
        viewController.present(alertController, animated: true)
    }
    
    // Дефолтный алерт с кнопкой "ОК"
    func showStandardAlert(from viewController: UIViewController,
                           title: String,
                           message: String?
    ) {
        let okAction = UIAlertAction(title: "ОК",
                                     style: .default)
        showAlert(from: viewController,
                  title: title,
                  message: message,
                  actions: [okAction])
    }
    
    // Алерт с выбором действий
    func showChoiceAlert(from viewController: UIViewController,
                         title: String,
                         message: String?,
                         choices: [String],
                         completion: @escaping (String) -> Void
    ) {
        let alertController = UIAlertController(title: title,
                                                message: message,
                                                preferredStyle: .alert)
        choices.forEach { choice in
            let action = UIAlertAction(title: choice,
                                       style: .default) { _ in
                completion(choice)
            }
            alertController.addAction(action)
        }
        viewController.present(alertController, animated: true)
    }
}
