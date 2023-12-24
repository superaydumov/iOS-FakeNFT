//
//  AlertPresenterDelegateProtocol.swift
//  FakeNFT
//
//  Created by Ян Максимов on 22.12.2023.
//

import UIKit

protocol AlertPresenterDelegate: AnyObject {
    func presentAlertController(_ alertController: UIAlertController)
}
