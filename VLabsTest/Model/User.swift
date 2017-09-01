//
//  User.swift
//  VLabsTest
//
//  Created by Fadi William Ghali ABDELMESSIH on 8/9/17.
//  Copyright © 2017 Levioza. All rights reserved.
//

import Foundation
import ObjectMapper

class User: NSObject, Mappable {
    
    // MARK: - Instance properties.
   
    var id: Int!;
    var name: String?;
    var username: String?;
    var email: String?;
    var phone: String?;
    var website: String?;
    var address: Address?;
    var company: Company?;
    
    // MARK: - Initializers.
    
    init(id: Int, name: String, username: String, email: String, phone: String, website: String,
         address: Address, company: Company) {
        self.id = id;
        self.name = name;
        self.username = username;
        self.email = email;
        self.phone = phone;
        self.website = website;
        self.address = address;
        self.company = company;
    }
    
    override convenience init() {
        self.init(id: 0, name: "", username: "", email: "", phone: "", website: "", address: Address(), company: Company());
    }
    
    // MARK: - Object mapper protocol.
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        id <- map["id"];
        name <- map["name"];
        username <- map["username"];
        email <- map["email"];
        phone <- map["phone"];
        website <- map["website"];
        address <- map["address"];
        company <- map["company"];
    }
    
    // MARK: - Additional functions.
    
    func getInitials() -> String {
        let userNameArray = self.name?.components(separatedBy: " ")
        let firstName = userNameArray?[0]
        let lastName = userNameArray?[1]
        let userNameInitials = "\(firstName!.characters[firstName!.characters.startIndex]).\(lastName!.characters[lastName!.characters.startIndex])."
        return userNameInitials;
    }
    
    // MARK: - Object description.
    
    override var description: String {
        return "\(User.self):\n\t" +
            "id: \(id)\n\t" +
            "name: \(String(describing: name))\n\t" +
            "username: \(String(describing: username))\n\t" +
            "email: \(String(describing: email))\n\t" +
            "phone: \(String(describing: phone))\n\t" +
            "website: \(String(describing: website))\n\t" +
            "address: \(String(describing: address))\n\t" +
            "company: \(String(describing: company))\n\t";
    }
}
