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
        var updatedState = gameState
        updatedState = updateResources(gameState: updatedState)
        updatedState = updateMonsters(gameState: updatedState)
        GameState.shared = updatedState
        NotificationCenter.default.post(name: GameEngine.gameUpdatedNotification, object: nil)
        run()
    }
    
    private func updateResources(gameState: GameState) -> GameState {
        var updatedState = gameState
        
        for territory in gameState.territories {
            guard !territory.assignedVillagers.isEmpty else { continue }
            
            switch territory.type {
            case .empty:
                break
            case .house:
                break
            case .farming:
                updatedState.addResource(type: .food, amount: territory.assignedVillagers.count)
                updatedState = updateExperience(for: territory.assignedVillagers, levelType: .farming, gameState: updatedState, amount: territory.assignedVillagers.count)
            case .fishing:
                updatedState.addResource(type: .food, amount: territory.assignedVillagers.count)
                updatedState = updateExperience(for: territory.assignedVillagers, levelType: .fishing, gameState: updatedState, amount: territory.assignedVillagers.count)
            case .hunting:
                updatedState.addResource(type: .food, amount: territory.assignedVillagers.count)
                updatedState = updateExperience(for: territory.assignedVillagers, levelType: .hunting, gameState: updatedState, amount: territory.assignedVillagers.count)
            case .woodChopping:
                let amount = min(updatedState.currentResourceAmount(of: .food), territory.assignedVillagers.count)
                updatedState.addResource(type: .wood, amount: amount)
                updatedState.addResource(type: .food, amount: -amount)
                updatedState = updateExperience(for: territory.assignedVillagers, levelType: .woodChopping, gameState: updatedState, amount: amount)
            }
        }
        
        return updatedState
    }
    
    private func updateMonsters(gameState: GameState) -> GameState {
        var updatedState = gameState
        
        for (index, var monster) in gameState.monsters.enumerated() {
            guard !monster.assignedVillagers.isEmpty, monster.currentHealth > 0 else { continue }
            
            let amount = min(updatedState.currentResourceAmount(of: .food), monster.assignedVillagers.count)
            
            monster.currentHealth = max(monster.currentHealth - amount, 0)
            if monster.currentHealth == 0 {
                monster.assignedVillagers = []
                updatedState.territories.append(Territory(type: .empty, maxOccupancy: 0, assignedVillagers: []))
            }
            
            updatedState.monsters[index] = monster
            
            updatedState = updateExperience(for: monster.assignedVillagers, levelType: .fighting, gameState: updatedState, amount: amount)
            updatedState.addResource(type: .food, amount: -amount)
        }
        
        return updatedState
    }
    
    private func updateExperience(for villagerNames: [String], levelType: LevelType, gameState: GameState, amount: Int) -> GameState {
        var updatedState = gameState
        
        for villagerName in villagerNames.prefix(amount) {
            let index = updatedState.villagers.firstIndex { $0.name == villagerName }!
            var villager = updatedState.villagers[index]
            var level = villager.levels[levelType] ?? Level.initialLevel(of: levelType)
            level.currentExperience = min(level.currentExperience + 1, level.maxExperience)
            villager.levels[levelType] = level
            updatedState.villagers[index] = villager
        }
        
        return updatedState
    }
}
