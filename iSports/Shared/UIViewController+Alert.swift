import UIKit

extension UIViewController {

    func showNoInternetAlert() {

        guard presentedViewController == nil else { return }

        
        let alert = UIAlertController(
            title: "Connection Error",
            message: "An internet connection is required to view this content. Please reconnect and try again.",
            preferredStyle: .alert
        )

        alert.addAction(
            UIAlertAction(
                title: NSLocalizedString("OK", comment: ""),
                style: .default
            )
        )

        present(alert, animated: true)
    }
}
