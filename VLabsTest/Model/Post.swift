//
//  Post.swift
//  VLabsTest
//
//  Created by Fadi William Ghali ABDELMESSIH on 8/9/17.
//  Copyright © 2017 Levioza. All rights reserved.
//

import Foundation
import ObjectMapper

class Post: NSObject, Mappable {
    
    // MARK: - Instance properties.
    
    var id: Int?;
    var title: String?;
    var body: String?;
    
    // Relations.
    var userId: Int?;
    
    // MARK: - Initializers.
    
    init(id: Int, title: String, body: String, userId: Int) {
        self.id = id;
        self.title = title;
        self.body = body;
        self.userId = userId;
    }
    
    override convenience init() {
        self.init(id: 0, title: "", body: "", userId: 0)
    }
    
    // MARK: - Object mapper protocol.
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        id <- map["id"];
        title <- map["title"];
        body <- map["body"];
        userId <- map["userId"];
    }
    
    // MARK: - Object description.
    
    override var description: String {
        return "\(Post.self):\n\t" +
            "id: \(String(describing: id))\n\t" +
            "title: \(String(describing: title))\n\t" +
            "body: \(String(describing: body))\n\t" +
            "userId: \(String(describing: userId))\n\t";
    }
}
