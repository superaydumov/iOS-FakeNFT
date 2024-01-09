import Foundation

struct AlertModel {
    let title: String
    let message: String?
    let firstButtonText: String
    let secondButtontext: String
    let firstCompletion: () -> Void
}
