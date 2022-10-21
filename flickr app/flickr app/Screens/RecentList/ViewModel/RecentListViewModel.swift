//
//  RecentListViewModel.swift
//  flickr app
//
//  Created by Abdullah Genc on 16.10.2022.
//

import Foundation
import FirebaseFirestore

enum RecentListChanges {
    case didErrorOccurred(_ error: Error)
    case didFetchList
}

final class RecentListViewModel {
    
    private var photosResponse: PhotosResponse? {
        didSet {
            self.changeHandler?(.didFetchList)
        }
    }
    
    private let db = Firestore.firestore()
    
    private let defaults = UserDefaults.standard
    
    var changeHandler: ((RecentListChanges) -> Void)?
    
    var numberOfRows: Int {
        photosResponse?.photos?.photo?.count ?? .zero
    }
    
    func fetchRecentList() {
        provider.request(.getRecent) { result in
            switch result {
            case .failure(let error):
                self.changeHandler?(.didErrorOccurred(error))
            case .success(let response):
                do {
                    let photosResponse = try JSONDecoder().decode(PhotosResponse.self, from: response.data)
                    
                    self.addPhotosToFirebaseFirestore(photosResponse.photos?.photo)
                    
                    self.photosResponse = photosResponse
                } catch {
                    self.changeHandler?(.didErrorOccurred(error))
                }
            }
        }
    }
    
    private func addPhotosToFirebaseFirestore(_ photos: [Photo]?) {
        guard let photos = photos else {
            return
        }
        photos.forEach { photo in
            do {
                guard let data = try photo.dictionary, let id = photo.id else {
                    return
                }
                
                db.collection("photos").document(id).setData(data) { error in
                    
                    if let error = error {
                        self.changeHandler?(.didErrorOccurred(error))
                    }
                }
            } catch {
                self.changeHandler?(.didErrorOccurred(error))
            }
        }
    }

    func photoForIndexPath(_ indexPath: IndexPath) -> Photo? {
        photosResponse?.photos?.photo?[indexPath.row]
    }
    
    func addFavorite(_ indexPath: IndexPath) {
        guard let id = photoForIndexPath(indexPath)?.id,
              let uid = defaults.string(forKey: UserDefaultConstants.uid.rawValue) else {
            return
        }
        db.collection("users").document(uid).updateData([
            "favorites": FieldValue.arrayUnion([id])
        ])
    }
    
    func removeFavorite(_ indexPath: IndexPath) {
        guard let id = photoForIndexPath(indexPath)?.id,
              let uid = defaults.string(forKey: UserDefaultConstants.uid.rawValue) else {
            return
        }
        db.collection("users").document(uid).updateData([
            "favorites": FieldValue.arrayRemove([id])
        ])
    }
    
    func addBookmark(_ indexPath: IndexPath) {
        guard let id = photoForIndexPath(indexPath)?.id,
              let uid = defaults.string(forKey: UserDefaultConstants.uid.rawValue) else {
            return
        }
        
        db.collection("users").document(uid).updateData([
            "bookmarks": FieldValue.arrayUnion([id])
        ])
    }
    
    func removeBookmark(_ indexPath: IndexPath) {
        guard let id = photoForIndexPath(indexPath)?.id,
              let uid = defaults.string(forKey: UserDefaultConstants.uid.rawValue) else {
            return
        }
        db.collection("users").document(uid).updateData([
            "bookmarks": FieldValue.arrayRemove([id])
        ])
    }
}
