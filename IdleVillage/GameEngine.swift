//
//  GameEngine.swift
//  IdleVillage
//
//  Created by Nick Shelley on 11/6/18.
//  Copyright © 2018 Mine. All rights reserved.
//

import Foundation

struct GameEngine {
    static var shared = GameEngine()
    
    static let gameUpdatedNotification = Notification.Name(rawValue: "GameUpdatedNotification")
    
    func run() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: { self.updateState() })
    }
    
    func updateState() {
        let gameState = GameState.shared!
        
        let existingFood = gameState.resources[.food]?.amount ?? 0
        var newFood = existingFood
        for territory in gameState.territories {
            guard !territory.assignedVillagers.isEmpty else { continue }
            
            switch territory.type {
            case .empty:
                break
            case .house:
                break
            case .farming:
                fallthrough
            case .fishing:
                fallthrough
            case .hunting:
                newFood += territory.assignedVillagers.count
            case .woodChopping:
                let amount = min(newFood, territory.assignedVillagers.count)
                var wood = gameState.resources[.wood, default: Resource(type: .wood, amount: 0)]
                wood.amount += amount
                GameState.shared.resources[.wood] = wood
                newFood -= amount
            }
        }
        
        GameState.shared.resources[.food] = Resource(type: .food, amount: newFood)
        
        NotificationCenter.default.post(name: GameEngine.gameUpdatedNotification, object: nil)
        run()
    }
}
