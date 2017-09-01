//
//  Company.swift
//  VLabsTest
//
//  Created by Fadi William Ghali ABDELMESSIH on 8/9/17.
//  Copyright © 2017 Levioza. All rights reserved.
//

import Foundation
import ObjectMapper

class Company: NSObject, Mappable {
    
    // MARK: - Instance properties.
    
    var name: String?;
    var catchPhrase: String?;
    var bs: String?;
    
    // MARK: - Initializers.
    
    init(name: String, catchPhrase: String, bs: String) {
        self.name = name;
        self.catchPhrase = catchPhrase;
        self.bs = bs;
    }
    
    override convenience init() {
        self.init(name: "", catchPhrase: "", bs: "")
    }
    
    // MARK: - Object mapper protocol.
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        name <- map["name"];
        catchPhrase <- map["catchPhrase"];
        bs <- map["bs"];
    }
    
    // MARK: - Object description.
    
    override var description: String {
        return "\(Company.self):\n\t" +
            "name: \(String(describing: name))\n\t" +
            "catchPhrase: \(String(describing: catchPhrase))\n\t" +
            "bs: \(String(describing: bs))\n\t";
    }
}
