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
        loadGameState()
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: 120, height: 120)
        let space: CGFloat = 12
        flowLayout.minimumInteritemSpacing = space
        flowLayout.sectionInset = UIEdgeInsets(top: space, left: space, bottom: space, right: space)
        let territoryViewController = TerritoryViewController(collectionViewLayout: flowLayout)
        territoryViewController.tabBarItem = UITabBarItem(title: "Territory", image: nil, tag: 0)
        
        rootViewController.viewControllers = [territoryViewController]
        rootViewController.selectedViewController = territoryViewController
    }
    
    private func loadGameState() {
        GameState.shared = GameState.makeInitial()
    }
}
