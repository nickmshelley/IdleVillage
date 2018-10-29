//
//  GameState.swift
//  IdleVillage
//
//  Created by Nick Shelley on 10/17/18.
//  Copyright © 2018 Mine. All rights reserved.
//

import Foundation

struct GameState: Codable {
    static var shared: GameState!
    
    var resources: [ResourceType: Resource]
    var villagers: [Villager]
    var territories: [Territory]
    var monsters: [Monster]
    
    static func filePath() -> String {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last!.appendingPathComponent("UserData.sqlite").path
    }
    
    static func makeInitial() -> GameState {
        let villagers = [Villager(name: "Bob", levels: [:])]
        
        let house = Territory(type: .house, maxOccupancy: 1, assignedVillagers: ["Bob"])
        let farming = Territory(type: .farming, maxOccupancy: 1, assignedVillagers: [])
        let fishing = Territory(type: .fishing, maxOccupancy: 1, assignedVillagers: [])
        let hunting = Territory(type: .hunting, maxOccupancy: 1, assignedVillagers: [])
        let wood = Territory(type: .woodChopping, maxOccupancy: 1, assignedVillagers: [])
        let territories = [house, farming, fishing, hunting, wood]
        
        let monsters = (0...10).map { Monster(health: Int(10 * pow(2, Double($0)))) }
        
        return GameState(resources: [:], villagers: villagers, territories: territories, monsters: monsters)
    }
}
