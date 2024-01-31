import UIKit
import ProgressHUD

extension ProgressHUD {
    private static var window: UIWindow? {
        return UIApplication.shared.windows.first
    }

    private static var loaderView: UIView?

    static func showCustomLoader() {
        self.loaderView = UIView(frame: CGRect(x: 0, y: 0, width: 25, height: 25))

        guard let loaderView else { return }
        loaderView.backgroundColor = .clear
        loaderView.center = window?.center ?? CGPoint.zero

        let activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0,
                                                                      width: loaderView.frame.width,
                                                                      height: loaderView.frame.height))
        activityIndicator.startAnimating()
        loaderView.addSubview(activityIndicator)

        window?.isUserInteractionEnabled = false
        window?.addSubview(loaderView)
    }

    static func hideCustomLoader() {
        window?.isUserInteractionEnabled = true
        loaderView?.removeFromSuperview()
    }
}
