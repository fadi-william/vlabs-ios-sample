//
//  FormExtension.swift
//  VLabsTest
//
//  Created by Fadi William Ghali ABDELMESSIH on 8/29/17.
//  Copyright © 2017 Levioza. All rights reserved.
//

import Eureka

extension Form {
    
    // Adding a clean state to a eureka form.
    public func isClean() ->Bool {
        for row in rows {
            if row.wasChanged {
                return false
            }
        }
        return true
    }
}
