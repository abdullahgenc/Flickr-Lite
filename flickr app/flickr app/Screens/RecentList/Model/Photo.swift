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
    let ownername: String?
}
