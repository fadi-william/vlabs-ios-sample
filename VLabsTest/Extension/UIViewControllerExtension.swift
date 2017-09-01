//
//  UIViewControllerExtension.swift
//  VLabsTest
//
//  Created by Fadi William Ghali ABDELMESSIH on 8/24/17.
//  Copyright © 2017 Levioza. All rights reserved.
//

import UIKit

extension UIViewController {
    
    // Set the view controller's adjusted title.
    func setAdjustedTitle(_ title: String) {
        // Get the length of the title.
        let titleLength = title.characters.count
        
        // Set the current view controller's title.
        if titleLength < 15 {
            self.title = title
        } else {
            let index = title.index(title.startIndex, offsetBy: 15)
            self.title = "\(title.substring(to: index))..."
        }
    }
}
