//
//  UIViewController+Extension.swift
//  StocksUpdate
//
//  Created by Raymond Donkemezuo on 12/22/21.
//

import Foundation
import UIKit

extension UIViewController {
    public func showAlert(title: String?, message: String?) {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .default) { alert in }
            alertController.addAction(okAction)
           
           if let popOverPresentationController = alertController.popoverPresentationController {
                      popOverPresentationController.sourceView = self.view
                      popOverPresentationController.sourceRect = CGRect(x: 1.0, y: 1.0, width: self.view.bounds.width, height: self.view.bounds.height)
                  }
            self.present(alertController, animated: true, completion: nil)
        }
     }
}
