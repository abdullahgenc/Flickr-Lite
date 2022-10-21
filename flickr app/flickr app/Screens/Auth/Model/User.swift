//
//  User.swift
//  flickr app
//
//  Created by Abdullah Genc on 19.10.2022.
//

import Foundation

struct User: Encodable {

    let username: String?
    let email: String?
    let profileImage: String?
    let favorites: [String]?
    let bookmarks: [String]?
}

extension User {
    init(from dict: [String: Any]) {
        username = dict["username"] as? String
        email = dict["email"] as? String
        profileImage = dict["profileImage"] as? String
        favorites = dict["favorites"] as? [String]
        bookmarks = dict["bookmarks"] as? [String]
    }
}
