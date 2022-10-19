//
//  PhotoInfo.swift
//  flickr app
//
//  Created by Abdullah Genc on 19.10.2022.
//
import Foundation

// MARK: - PhotoInfos
struct PhotoInfos: Codable {
    let photo: Photo?
    let stat: String?
}

// MARK: - Photo
struct PhotoInfo: Codable {
    let id, secret, server: String?
    let farm: Int?
    let dateuploaded: String?
    let isfavorite: Int?
    let license, safetyLevel: String?
    let rotation: Int?
    let originalsecret, originalformat: String?
    let owner: Owner?
    let title, photoDescription: Description?
    let urls: Urls?
    let media: String?

    enum CodingKeys: String, CodingKey {
        case id, secret, server, farm, dateuploaded, isfavorite, license
        case safetyLevel = "safety_level"
        case rotation, originalsecret, originalformat, owner, title
        case photoDescription = "description"
        case urls, media
    }
}

// MARK: - Owner
struct Owner: Codable {
    let nsid, username, realname, location: String?
    let iconserver: String?
    let iconfarm: Int?
}

// MARK: - Description
struct Description: Codable {
    let content: String?

    enum CodingKeys: String, CodingKey {
        case content = "_content"
    }
}

// MARK: - Urls
struct Urls: Codable {
    let url: [URLElement]?
}

// MARK: - URLElement
struct URLElement: Codable {
    let type: String?
    let content: String?

    enum CodingKeys: String, CodingKey {
        case type
        case content = "_content"
    }
}

extension PhotoInfo {
    init(from dict: [String : Any]) {
        id = dict["id"] as? String
        farm = dict["farm"] as? Int
        secret = dict["secret"] as? String
        server = dict["server"] as? String
        dateuploaded = dict["dateuploaded"] as? String
        isfavorite = dict["isfavorite"] as? Int
        rotation = dict["rotation"] as? Int
        license = dict["license"] as? String
        safetyLevel = dict["safetyLevel"] as? String
        originalsecret = dict["originalsecret"] as? String
        originalformat = dict["originalformat"] as? String
        owner = dict["owner"] as? Owner
        title = dict["title"] as? Description
        photoDescription = dict["photoDescription"] as? Description
        urls = dict["urls"] as? Urls
        media = dict["media"] as? String
    }
}
