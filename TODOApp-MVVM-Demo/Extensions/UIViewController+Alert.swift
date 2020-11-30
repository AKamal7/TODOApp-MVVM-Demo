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
    
    func openAlert(title: String,
                   message: String,
                   alertStyle: UIAlertController.Style,
                   actionTitles: [String],
                   actionStyles: [UIAlertAction.Style],
                   actions: [((UIAlertAction) -> Void)?]?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: alertStyle)
        for (index, indexTitle) in actionTitles.enumerated() {
            let action = UIAlertAction(title: indexTitle, style: actionStyles[index], handler: actions?[index])
            alert.addAction(action)
        }
        self.present(alert, animated: true)

    }
}
