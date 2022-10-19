//
//  Photo.swift
//  flickr app
//
//  Created by Abdullah Genc on 16.10.2022.
//
import Foundation

// MARK: - PhotosResponse
struct PhotosResponse: Codable {
    let photos: Photos?
    let stat: String?
}

// MARK: - Photos
struct Photos: Codable {
    let page, pages, perpage, total: Int?
    let photo: [Photo]?
}

// MARK: - Photo
struct Photo: Codable {
    let id, owner, secret, server: String?
    let farm: Int?
    let title: String?
    let ispublic, isfriend, isfamily: Int?
    let ownername, iconserver: String?
    let iconfarm: Int?
}

extension Photo {
    var profileImageUrl: URL {
        guard let icon_farm = iconfarm?.description,
              let icon_server = iconserver,
              let nsid = owner else {
            fatalError("profile url not found")
        }
        if icon_farm == "0" || icon_server == "0" {
            let profileImageUrl = URL(string: "https://www.flickr.com/images/buddyicon.gif")
            return profileImageUrl!
        } else {
            let profileImageUrl = URL(string: "https://farm\(icon_farm).staticflickr.com/\(icon_server)/buddyicons/\(nsid).jpg")
            return profileImageUrl!
        }
    }
    
    var photoImageUrl: URL {
        guard let server_id = server,
              let secret = secret,
              let id = id,
              let photoImageUrl = URL(string: "https://live.staticflickr.com/\(server_id)/\(id)_\(secret).jpg") else {
            fatalError("photo url not found")
        }
        return photoImageUrl
    }
}

extension Photo {
    init(from dict: [String : Any]) {
        id = dict["id"] as? String
        owner = dict["owner"] as? String
        secret = dict["secret"] as? String
        server = dict["server"] as? String
        farm = dict["farm"] as? Int
        title = dict["title"] as? String
        ispublic = dict["ispublic"] as? Int
        isfriend = dict["isfriend"] as? Int
        isfamily = dict["isfamily"] as? Int
        ownername = dict["ownername"] as? String
        iconserver = dict["iconserver"] as? String
        iconfarm = dict["iconfarm"] as? Int
    }
}
