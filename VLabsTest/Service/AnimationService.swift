//
//  AnimationService.swift
//  VLabsTest
//
//  Created by Fadi William Ghali ABDELMESSIH on 8/23/17.
//  Copyright © 2017 Levioza. All rights reserved.
//

import UIKit

class AnimationService {
    
    // Create an ease-in ease-out animation transition.
    static func createAnimation(withDirection: String) -> CATransition {
        let transition = CATransition()
        transition.duration = 1.0
        transition.type = kCATransitionPush
        transition.subtype = withDirection
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        return transition
    }
    
    // Prevent other objects from instantiating this class.
    private init() {}
}
