//
//  UIViewController+Alert.swift
//  TODOApp-MVC-Demo
//
//  Created by Kamal on 11/4/20.
//  Copyright © 2020 IDEAEG. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    func showAlert(title: String, message: String, actionTitle: String, handler: ((UIAlertAction) -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: actionTitle, style: .cancel, handler: handler))
        self.present(alert, animated: true)
    }
}
