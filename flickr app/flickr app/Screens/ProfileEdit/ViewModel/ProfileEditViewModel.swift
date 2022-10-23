//
//  ProfileEditsViewModel.swift
//  flickr app
//
//  Created by Abdullah Genc on 23.10.2022.
//

import UIKit
import FirebaseStorage
import FirebaseAuth
import FirebaseFirestore

protocol ProfileEditProtocol: AnyObject {
    func didErrorOccurred(_ error: Error)
    func didFetchImage(_ image: URL)
    func didSaveUser()
}

final class ProfileEditViewModel: FViewModel {
    weak var delegate: ProfileEditProtocol?
    private let defaults = UserDefaults.standard
    private let ref = Storage.storage().reference()
    
    func saveImagePicker(image: UIImage?) {
        guard let imageData = image?.pngData() else {
            return
        }
        guard let uid = uid else {
            return
        }
        ref.child("images/\(uid).png").putData(imageData) { _, error in
            if let error {
                self.delegate?.didErrorOccurred(error)
                return
            }
            self.fetchImage()
        }
    }
    
    func fetchImage() {
        guard let uid = uid else { return }
        ref.child("images/\(uid).png").downloadURL { url, error in
            if let error {
                self.delegate?.didErrorOccurred(error)
            }
            guard let url = url else {
                return
            }
            self.delegate?.didFetchImage(url.absoluteURL)
            self.db.collection("users").document(uid).updateData([
                "profileImage": url.description
            ])
        }
    }
    
    func fetchUsername() -> String{
        Auth.auth().currentUser?.displayName ?? ""
    }
    
    func save(username: String?) {
        guard let uid = uid,
              let username = username else { return }
        
        let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
        changeRequest?.displayName = username
        changeRequest?.commitChanges { error in
            if let error {
                self.delegate?.didErrorOccurred(error)
            }
            self.delegate?.didSaveUser()
            self.db.collection("users").document(uid).updateData([
                "username": username
            ])
        }
    }
}
