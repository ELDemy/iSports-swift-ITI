//
//  UIViewController+Alert.swift
//  MAD46_Sports
//
//  Created by JETSMobileLabMini3 on 08/05/2026.
//

import UIKit

extension UIViewController {
    func showNoInternetAlert() {
        let alert = UIAlertController(
            title: NSLocalizedString("NO_INTERNET" , comment: ""),
            message: NSLocalizedString("NO_INTERNET_MSG", comment: ""),
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
