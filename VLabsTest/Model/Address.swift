//
//  Address.swift
//  VLabsTest
//
//  Created by Fadi William Ghali ABDELMESSIH on 8/9/17.
//  Copyright © 2017 Levioza. All rights reserved.
//

import Foundation
import ObjectMapper

class Address: NSObject, Mappable {
    
    // MARK: - Instance properties.
    
    var street: String?;
    var suite: String?;
    var city: String?;
    var zipCode: String?;
    var geoLocation: GeoLocation?;
    
    // MARK: - Initializers.
    
    init(street: String, suite: String, city: String, zipCode: String, geoLocation: GeoLocation) {
        self.street = street;
        self.suite = suite;
        self.city = city;
        self.zipCode = zipCode;
        self.geoLocation = geoLocation;
    }
    
    override convenience init() {
        self.init(street: "", suite: "", city: "", zipCode: "", geoLocation: GeoLocation());
    }
    
    // MARK: - Object mapper protocol.
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        street <- map["street"];
        suite <- map["suite"];
        city <- map["city"];
        zipCode <- map["zipcode"];
        geoLocation <- map["geo"];
    }
    
    // MARK: - Object description.
    
    override var description: String {
        return "\(Address.self):\n\t" +
            "street: \(String(describing: street))\n\t" +
            "suite: \(String(describing: suite))\n\t" +
            "city: \(String(describing: city))\n\t" +
            "zipCode: \(String(describing: zipCode))\n\t" +
            "geoLocation: \(String(describing: geoLocation))\n\t";
    }
}
