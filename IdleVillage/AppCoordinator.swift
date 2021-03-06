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
        let territoryResources = ResourcesViewController(child: TerritoriesViewController(collectionViewLayout: flowLayout))
        let territoryViewController = UINavigationController(rootViewController: territoryResources)
        territoryViewController.tabBarItem = UITabBarItem(title: "Territory", image: nil, tag: 0)
        
        let villagerResources = ResourcesViewController(child: VillagersTableViewController())
        let villagersController = UINavigationController(rootViewController: villagerResources)
        villagersController.tabBarItem = UITabBarItem(title: "Villagers", image: nil, tag: 0)
        
        rootViewController.viewControllers = [territoryViewController, villagersController]
        rootViewController.selectedViewController = territoryViewController
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleGameUpdate), name: GameEngine.gameUpdatedNotification, object: nil)
        
        GameEngine.shared.run()
    }
    
    @objc func handleGameUpdate() {
        rootViewController.viewControllers![0].tabBarItem.badgeValue = GameState.shared.territoryActionAvailable() ? "!" : nil
        rootViewController.viewControllers![1].tabBarItem.badgeValue = GameState.shared.villagerActionAvailable() ? "!" : nil
    }
    
    private func loadGameState() {
        guard let data = UserDefaults.standard.data(forKey: "GameState") else { return GameState.shared = GameState.makeInitial() }
        
        let decoder = JSONDecoder()
        let gameState = try! decoder.decode(GameState.self, from: data)
        GameState.shared = gameState
    }
    
    func saveGameState() {
        let encoder = JSONEncoder()
        let data = try! encoder.encode(GameState.shared)
        UserDefaults.standard.set(data, forKey: "GameState")
    }
}
