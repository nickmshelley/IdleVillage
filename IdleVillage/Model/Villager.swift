//
//  Villager.swift
//  IdleVillage
//
//  Created by Nick Shelley on 10/17/18.
//  Copyright © 2018 Mine. All rights reserved.
//

import Foundation

struct Villager: Codable {
    let name: String
    var levels: [LevelType: Level]
    var assignedTerritory: String
    
    mutating func levelUp(type: LevelType) {
        var level = levels[type] ?? Level.initialLevel(of: type)
        if level.currentLevel == level.maxLevel {
            level.currentLevel = 1
            level.maxLevel += 5
            level.maxExperience = 10
        } else {
            level.currentLevel += 1
            level.maxExperience += 10
        }
        
        level.currentExperience = 0
        
        levels[type] = level
    }
    
    init(name: String, levels: [LevelType: Level] = [:], assignedTerritory: String = "Unassigned") {
        self.name = name
        self.levels = levels
        self.assignedTerritory = assignedTerritory
    }
}
