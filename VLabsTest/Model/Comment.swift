//
//  Comment.swift
//  VLabsTest
//
//  Created by Fadi William Ghali ABDELMESSIH on 8/9/17.
//  Copyright © 2017 Levioza. All rights reserved.
//

import Foundation
import ObjectMapper

class Comment: NSObject, Mappable {
    
    // MARK: - Instance properties.
    
    var id: Int?;
    var name: String?;
    var email: String?;
    var body: String?;
    
    // Relations.
    var postId: Int?;
    
    // MARK: - Initializers.
    
    init(id: Int, name: String, email: String, body: String, postId: Int) {
        self.id = id;
        self.name = name;
        self.email = email;
        self.body = body;
        self.postId = postId;
    }
    
    init(name: String, email: String, body: String, postId: Int) {
        self.id = 0;
        self.name = name;
        self.email = email;
        self.body = body;
        self.postId = postId;
    }
    
    override convenience init() {
        self.init(id: 0, name: "", email: "", body: "", postId: 0);
    }
    
    // MARK: - Object mapper protocol.
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        id <- map["id"];
        name <- map["name"];
        email <- map["email"];
        body <- map["body"];
        postId <- map["postId"];
    }
    
    // MARK: - Object description.
    
    override var description: String {
        return "\(Post.self):\n\t" +
            "id: \(String(describing: id))\n\t" +
            "name: \(String(describing: name))\n\t" +
            "email: \(String(describing: email))\n\t" +
            "body: \(String(describing: body))\n\t" +
            "postId: \(String(describing: postId))\n\t";
    }
}
