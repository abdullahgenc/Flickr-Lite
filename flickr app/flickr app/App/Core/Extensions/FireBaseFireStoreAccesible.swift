//
//  FireBaseFireStoreAccesible.swift
//  flickr app
//
//  Created by Abdullah Genc on 19.10.2022.
//

import Foundation
import FirebaseFirestore

protocol FireBaseFireStoreAccessible {}

extension FireBaseFireStoreAccessible {
    var db: Firestore {
        Firestore.firestore()
    }
}
