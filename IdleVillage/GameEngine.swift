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
    
    private func updateState(gameState: GameState = GameState.shared!) {
        updateResources(gameState: gameState)
        updateExperience()
        NotificationCenter.default.post(name: GameEngine.gameUpdatedNotification, object: nil)
        run()
    }
    
    private func updateResources(gameState: GameState) {
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
    }
    
    private func updateExperience() {
        for territory in GameState.shared.territories {
            guard !territory.assignedVillagers.isEmpty else { continue }
            
            let optionalLevelType: LevelType?
            switch territory.type {
            case .empty:
                optionalLevelType = nil
            case .house:
                optionalLevelType = nil
            case .farming:
                optionalLevelType = .farming
            case .fishing:
                optionalLevelType = .fishing
            case .hunting:
                optionalLevelType = .hunting
            case .woodChopping:
                optionalLevelType = .woodChopping
            }
            
            guard let levelType = optionalLevelType else { continue }
            
            for villagerName in territory.assignedVillagers {
                let index = GameState.shared.villagers.firstIndex { $0.name == villagerName }!
                var villager = GameState.shared.villagers[index]
                var level = villager.levels[levelType] ?? Level.initialLevel(of: levelType)
                level.currentExperience = min(level.currentExperience + 1, level.maxExperience)
                villager.levels[levelType] = level
                GameState.shared.villagers[index] = villager
            }
        }
    }
}
