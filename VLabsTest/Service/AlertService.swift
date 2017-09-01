//
//  AlertService.swift
//  VLabsTest
//
//  Created by Fadi William Ghali ABDELMESSIH on 8/23/17.
//  Copyright © 2017 Levioza. All rights reserved.
//

import UIKit


class AlertService {
    
    // Show a generic alert.
    static func showGenericAlert(_ title: String, message: String, viewController: UIViewController) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(ok)
        viewController.present(alertController, animated: true, completion: nil)
    }
    
    // Prevent other objects from instantiating this class.
    private init() {}
}
