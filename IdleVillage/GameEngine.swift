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
        DispatchQueue.main.asyncAfter(deadline: .now() + (GameState.debug ? 1 : 3), execute: { self.updateState() })
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
                let amount = villagerPower(for: territory.assignedVillagers, levelType: .farming, gameState: updatedState, amount: territory.assignedVillagers.count)
                updatedState.addResource(type: .food, amount: amount * territory.level)
                updatedState = updateExperience(for: territory.assignedVillagers, levelType: .farming, gameState: updatedState, amount: territory.assignedVillagers.count)
            case .woodChopping:
                let turns = min(updatedState.currentResourceAmount(of: .food), territory.assignedVillagers.count)
                let amount = villagerPower(for: territory.assignedVillagers, levelType: .woodChopping, gameState: updatedState, amount: turns)
                updatedState.addResource(type: .wood, amount: amount * territory.level)
                updatedState.addResource(type: .food, amount: -turns)
                updatedState = updateExperience(for: territory.assignedVillagers, levelType: .woodChopping, gameState: updatedState, amount: turns)
            case .stone:
                let turns = min(updatedState.currentResourceAmount(of: .food), territory.assignedVillagers.count)
                let amount = villagerPower(for: territory.assignedVillagers, levelType: .mining, gameState: updatedState, amount: turns)
                updatedState.addResource(type: .stone, amount: amount * territory.level)
                updatedState.addResource(type: .food, amount: -turns)
                updatedState = updateExperience(for: territory.assignedVillagers, levelType: .mining, gameState: updatedState, amount: turns)
            case .management:
                break
            case .research:
                break
            }
        }
        
        return updatedState
    }
    
    private func updateMonsters(gameState: GameState) -> GameState {
        var updatedState = gameState
        
        for (index, var monster) in gameState.monsters.enumerated() {
            guard !monster.assignedVillagers.isEmpty, monster.currentHealth > 0 else { continue }
            
            let turns = min(updatedState.currentResourceAmount(of: .food), monster.assignedVillagers.count)
            let amount = villagerPower(for: monster.assignedVillagers, levelType: .fighting, gameState: updatedState, amount: turns)
            
            monster.currentHealth = max(monster.currentHealth - amount, 0)
            if monster.currentHealth == 0 {
                monster.assignedVillagers = []
                updatedState.territories.append(Territory(type: .empty, maxOccupancy: 0))
            }
            
            updatedState.monsters[index] = monster
            
            updatedState = updateExperience(for: monster.assignedVillagers, levelType: .fighting, gameState: updatedState, amount: turns)
            updatedState.addResource(type: .food, amount: -turns)
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
    
    private func villagerPower(for villagerNames: [String], levelType: LevelType, gameState: GameState, amount: Int) -> Int {
        return villagerNames.prefix(amount).map { name in
            let villager = gameState.villagers.first { $0.name == name }!
            return villager.levels[levelType]?.currentLevel ?? 1
        }.reduce(0, +)
    }
}
