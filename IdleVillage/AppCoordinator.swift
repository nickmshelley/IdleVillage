//
//  AppCoordinator.swift
//  IdleVillage
//
//  Created by Heather Shelley on 10/13/18.
//  Copyright © 2018 Mine. All rights reserved.
//

import UIKit

final class AppCoordinator {
    let rootViewController: UITabBarController
    
    init(rootViewController: UITabBarController) {
        self.rootViewController = rootViewController
    }
    
    func start() {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: 30, height: 30)
        let territoryViewController = TerritoryViewController(collectionViewLayout: flowLayout)
        territoryViewController.tabBarItem = UITabBarItem(title: "Territory", image: nil, tag: 0)
        
        rootViewController.viewControllers = [territoryViewController]
        rootViewController.selectedViewController = territoryViewController
    }
}
