//
//  Album.swift
//  VLabsTest
//
//  Created by Fadi William Ghali ABDELMESSIH on 8/9/17.
//  Copyright © 2017 Levioza. All rights reserved.
//

import Foundation
import ObjectMapper

class Album: NSObject, Mappable {
    
    // MARK: - Instance properties.
    
    var id: Int?;
    var title: String?;
    
    // Relations.
    var userId: Int?;
    
    // MARK: - Initializers.
    
    init(id: Int, title: String, userId: Int) {
        self.id = id;
        self.title = title;
        self.userId = userId;
    }
    
    override convenience init() {
        self.init(id: 0, title: "", userId: 0)
    }
    
    // MARK: - Object mapper protocol.
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        id <- map["id"];
        title <- map["title"];
        userId <- map["userId"];
    }
    
    // MARK: - Additional functions.
    
    func getInitials() -> String {
        let albumNameArray = self.title?.components(separatedBy: " ")
        var albumInitials = ""
        
        // We will get the first 2 words only. If there are more than 2 words.
        var count = 2
        for part in albumNameArray! {
            albumInitials.append("\(part.characters[part.characters.startIndex]).")
            count = count - 1
            if count == 0 {
                break;
            }
        }
        return albumInitials
    }
    
    // MARK: - Object description.
    
    override var description: String {
        return "\(Album.self):\n\t" +
            "id: \(String(describing: id))\n\t" +
            "title: \(String(describing: title))\n\t" +
            "userId: \(String(describing: userId))\n\t";
    }
}
