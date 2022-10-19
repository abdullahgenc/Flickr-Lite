//
//  AppDelegate.swift
//  flickr app
//
//  Created by Abdullah Genc on 16.10.2022.
//

import UIKit
import FirebaseCore
import FirebaseFirestore

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        setupFirebase()
        setupWindow()
        
        return true
    }
    
    private func setupFirebase() {
        FirebaseApp.configure()
        
        _ = Firestore.firestore()
    }
    
    private func setupWindow() {
        // Override point for customization after application launch.
        
        let window = UIWindow(frame: UIScreen.main.bounds)

        let authViewController = AuthViewController(viewModel: AuthViewModel())
        let authNavigationController = UINavigationController(rootViewController: authViewController)
        
        window.rootViewController = authNavigationController
        window.makeKeyAndVisible()
        self.window = window
    }

}

