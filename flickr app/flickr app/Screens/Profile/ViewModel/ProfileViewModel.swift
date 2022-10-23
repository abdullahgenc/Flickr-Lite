//
//  ProfileViewModel.swift
//  flickr app
//
//  Created by Abdullah Genc on 18.10.2022.
//

import Foundation
import FirebaseFirestore

final class ProfileViewModel: FViewModel {
    
    private var photos = [Photo]()
    
    var numberOfRows: Int {
        photos.count
    }
    
    var username = String()
    var profileImage = String()
    
    func photoForIndexPath(_ indexPath: IndexPath) -> Photo? {
        photos[indexPath.row]
    }
    
    func fetchUser(_ completion: @escaping (Error?) -> Void) {
        
        guard let uid = uid else { return }
        
        db.collection("users").document(uid).getDocument() { (querySnapshot, err) in
            guard let data = querySnapshot?.data() else { return }
            let user = User(from: data)
            self.username = user.username!
            self.profileImage = user.profileImage!
            completion(nil)
        }
    }
    
    func fetchFavorites(_ completion: @escaping (Error?) -> Void) {
        
        photos = []
        guard let uid = uid else { return }
        
        db.collection("users").document(uid).getDocument() { (querySnapshot, err) in
            guard let data = querySnapshot?.data() else { return }
            let user = User(from: data)
            self.username = user.username!
            self.profileImage = user.profileImage!
            
            user.favorites?.forEach({ photoId in
                self.db.collection("photos").document(photoId).getDocument { (querySnapshot, err) in
                    if let err = err {
                        print(err.localizedDescription)
                        completion(err)
                    } else {
                        guard let data = querySnapshot?.data() else { return }
                        let photo = Photo(from: data)
                        self.photos.append(photo)
                        completion(nil)
                    }
                }
            })
        }
    }
    
    func fetchBookmarks(_ completion: @escaping (Error?) -> Void) {
        
        photos = []
        guard let uid = uid else { return }
        
        db.collection("users").document(uid).getDocument() { (querySnapshot, err) in
            guard let data = querySnapshot?.data() else { return }
            let user = User(from: data)
            self.username = user.username!
            self.profileImage = user.profileImage!
            self.profileImage = user.profileImage!
            
            user.bookmarks?.forEach({ photoId in
                self.db.collection("photos").document(photoId).getDocument { (querySnapshot, err) in
                    if let err = err {
                        print(err.localizedDescription)
                        completion(err)
                    } else {
                        guard let data = querySnapshot?.data() else { return }
                        let photo = Photo(from: data)
                        self.photos.append(photo)
                        completion(nil)
                    }
                }
            })
        }
    }
}
