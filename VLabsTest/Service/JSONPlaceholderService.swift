//
//  JSONPlaceholderService.swift
//  VLabsTest
//
//  Created by Fadi William Ghali ABDELMESSIH on 8/9/17.
//  Copyright © 2017 Levioza. All rights reserved.
//

import Foundation
import Moya

// Here we use a singleton to get the RxMoyaProvider of the JSONPlaceholderService.
class JPAPIServiceSingleton {
    static let sharedInstance = RxMoyaProvider<JSONPlaceholderService>()
    
    // Make a private initializer to prevent other objects from creating their own instance of the JPAPISingleton.
    private init() {}
}

enum JSONPlaceholderService {
    case getUsers
    case getUserPosts(userId: Int)
    case getPostComments(postId: Int)
    case postUserCommentOnPost(name: String, email: String, body: String, postId: Int)
    case getUserAlbums(userId: Int)
    case getAlbumPhotos(albumId: Int)
}

// MARK: - TargetType Protocol Implementation

extension JSONPlaceholderService: TargetType {
    var baseURL: URL { return URL(string: "https://jsonplaceholder.typicode.com")! }
    var path: String {
        switch self {
        case .getUsers:
            return "/users"
        case .getUserPosts:
            return "/posts"
        case .getPostComments:
            return "/comments"
        case .postUserCommentOnPost:
            return "/comments"
        case .getUserAlbums:
            return "/albums"
        case .getAlbumPhotos:
            return "/photos"
        };
    };
    var method: Moya.Method {
        switch self {
        case .getUsers, .getUserPosts, .getPostComments, .getUserAlbums, .getAlbumPhotos:
            return .get
        case .postUserCommentOnPost:
            return .post
        }
    };
    var parameters: [String: Any]? {
        switch self {
        case .getUsers:
            return nil
        case .getUserPosts(let userId):
            return ["userId": userId]
        case .getPostComments(let postId):
            return ["postId": postId]
        case .postUserCommentOnPost(let name, let email, let body, let postId):
            return ["name": name, "email": email, "body": body, "postId": postId]
        case .getUserAlbums(let userId):
            return ["userId": userId]
        case .getAlbumPhotos(let albumId):
            return ["albumId": albumId]
        }
    };
    var parameterEncoding: ParameterEncoding {
        switch self {
        case .getUsers, .getUserPosts, .getPostComments, .getUserAlbums, .getAlbumPhotos:
            return URLEncoding.default
        case .postUserCommentOnPost:
            return JSONEncoding.default
            
        }
    };
    var sampleData: Data {
        switch self {
        case .getUsers:
            // Load the data from users.json.
            guard let url = Bundle.main.url(forResource: "users", withExtension: "json"),
                let data = try? Data(contentsOf: url) else {
                    return Data()
            }
            return data
        case .getUserPosts:
            // Load the data from user_posts.json.
            guard let url = Bundle.main.url(forResource: "user_posts", withExtension: "json"),
                let data = try? Data(contentsOf: url) else {
                    return Data()
            }
            return data
        case .getPostComments:
            // Load the data from post_comments.json.
            guard let url = Bundle.main.url(forResource: "post_comments", withExtension: "json"),
                let data = try? Data(contentsOf: url) else {
                    return Data()
            }
            return data
        case .postUserCommentOnPost:
            // Load the data from post_comment.json.
            guard let url = Bundle.main.url(forResource: "post_comment", withExtension: "json"),
                let data = try? Data(contentsOf: url) else {
                    return Data()
            }
            return data
        case .getUserAlbums:
            // Load the data from user_albums.json.
            guard let url = Bundle.main.url(forResource: "user_albums", withExtension: "json"),
                let data = try? Data(contentsOf: url) else {
                    return Data()
            }
            return data
        case .getAlbumPhotos:
            // Load the data from album_photos.json.
            guard let url = Bundle.main.url(forResource: "album_photos", withExtension: "json"),
                let data = try? Data(contentsOf: url) else {
                    return Data()
            }
            return data
        }
    }
    var task: Task {
        switch self {
        case .getUsers, .getUserPosts, .getPostComments, .getUserAlbums, .getAlbumPhotos, .postUserCommentOnPost:
            return .request
        }
    };
    var headers: [String: String]? {
        return ["Content-type": "application/json"]
    };
}
