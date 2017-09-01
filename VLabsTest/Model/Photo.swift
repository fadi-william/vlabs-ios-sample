//
//  Photo.swift
//  VLabsTest
//
//  Created by Fadi William Ghali ABDELMESSIH on 8/9/17.
//  Copyright © 2017 Levioza. All rights reserved.
//

import Foundation
import ObjectMapper

class Photo: NSObject, Mappable {
    
    // MARK: - Instance properties.
    
    var id: Int?;
    var title: String?;
    var url: String?;
    var thumbnailUrl: String?;
    
    // Relations.
    var albumId: Int?;
    
    // MARK: - Initializers.
    
    init(id: Int, title: String, url: String, thumbnailUrl: String, albumId: Int) {
        self.id = id;
        self.title = title;
        self.url = url;
        self.thumbnailUrl = thumbnailUrl;
        self.albumId = albumId;
    }
    
    override convenience init() {
        self.init(id: 0, title: "", url: "", thumbnailUrl: "", albumId: 0);
    }
    
    // MARK: - Object mapper protocol.
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        id <- map["id"];
        title <- map["title"];
        url <- map["url"];
        thumbnailUrl <- map["thumbnailUrl"];
        albumId <- map["albumId"];
    }
    
    // MARK: - Object description.
    
    override var description: String {
        return "\(Photo.self):\n\t" +
            "id: \(String(describing: id))\n\t" +
            "title: \(String(describing: title))\n\t" +
            "url: \(String(describing: url))\n\t" +
            "thumbnailUrl: \(String(describing: thumbnailUrl))\n\t" +
            "albumId: \(String(describing: albumId))\n\t";
    }
}
