//
//  AppDelegate.swift
//  flickr app
//
//  Created by Abdullah Genc on 16.10.2022.
//

import UIKit
import FirebaseCore

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        setupWindow()
        FirebaseApp.configure()
        
        return true
    }
    
    private func setupWindow() {
        // Override point for customization after application launch.
        
        let window = UIWindow(frame: UIScreen.main.bounds)
        
        let images = ["house", "magnifyingglass", "person"]
        
        let authViewController = AuthViewController()
        
        let recentViewController = RecentListViewController(viewModel: PhotoViewModel())
        let recentNavigationController = UINavigationController(rootViewController: recentViewController)
        
        let searchViewController = SearchPhotoViewController(viewModel: PhotoViewModel())
        let searchNavigationController = UINavigationController(rootViewController: searchViewController)
        
        let profileViewController = ProfileViewController()
        let profileNavigationController = UINavigationController(rootViewController: profileViewController)
        
        let tabBarController = UITabBarController()
        tabBarController.viewControllers = [recentNavigationController, searchNavigationController, profileNavigationController]
        
        guard let items = tabBarController.tabBar.items else {
            return
        }
        
        for x in 0..<items.count {
            if #available(iOS 13.0, *) {
                items[x].image = UIImage(systemName: images[x])
            } else {
//                items[x].image = 
            }
        }
        
        window.rootViewController = tabBarController
        window.makeKeyAndVisible()
        self.window = window
    }

}

