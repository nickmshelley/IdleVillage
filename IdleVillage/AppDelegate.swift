//
//  AppDelegate.swift
//  IdleVillage
//
//  Created by Heather Shelley on 10/13/18.
//  Copyright © 2018 Mine. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    private var coordinator: AppCoordinator!
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let window = UIWindow(frame: UIScreen.main.bounds)
        let rootViewController = UITabBarController()
        coordinator = AppCoordinator(rootViewController: rootViewController)
        coordinator.start()
        window.rootViewController = rootViewController
        window.makeKeyAndVisible()
        self.window = window
        return true
    }
}

