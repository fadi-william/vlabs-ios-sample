//
//  GeoLocation.swift
//  VLabsTest
//
//  Created by Fadi William Ghali ABDELMESSIH on 8/9/17.
//  Copyright © 2017 Levioza. All rights reserved.
//

import Foundation
import ObjectMapper

class GeoLocation: NSObject, Mappable {
    
    // MARK: - Instance properties.
    
    var lat: String?;
    var long: String?;
    
    // MARK: - Initializers.
    
    init(lat: String, long: String) {
        self.lat = lat;
        self.long = long;
    }
    
    override convenience init() {
        self.init(lat: "", long: "");
    }
    
    // MARK: - Object mapper protocol.
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        lat <- map["lat"];
        long <- map["lng"];
    }
    
    // MARK: - Object description.
    
    override var description: String {
        return "\(GeoLocation.self):\n\t" +
            "latitude: \(String(describing: lat))\n\t" +
            "longitude: \(String(describing: long))\n\t";
    }
}
