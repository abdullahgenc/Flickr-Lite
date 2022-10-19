//
//  UserDefaultsAccesible.swift
//  flickr app
//
//  Created by Abdullah Genc on 19.10.2022.
//

import Foundation

protocol UserDefaultsAccessible {}

extension UserDefaultsAccessible {
    var defaults: UserDefaults {
        UserDefaults.standard
    }
    
    var uid: String? {
        stringDefault(for: .uid)
    }
    
    func stringDefault(for key: UserDefaultConstants) -> String? {
        defaults.string(forKey: key.rawValue)
    }
}
