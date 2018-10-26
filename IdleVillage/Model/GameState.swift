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
    
    var villagers: [Villager]
    var territories: [Territory]
    var monsters: [Monster]
    
    static func filePath() -> String {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last!.appendingPathComponent("UserData.sqlite").path
    }
    
    static func makeInitial() -> GameState {
        let villagers = [Villager(name: "Bob", levels: [:])]
        
        let house = Territory(type: .house, currentOccupancy: 1, maxOccupancy: 1)
        let farming = Territory(type: .farming, currentOccupancy: 0, maxOccupancy: 1)
        let fishing = Territory(type: .fishing, currentOccupancy: 0, maxOccupancy: 1)
        let hunting = Territory(type: .hunting, currentOccupancy: 0, maxOccupancy: 1)
        let wood = Territory(type: .woodChopping, currentOccupancy: 0, maxOccupancy: 1)
        let territories = [house, farming, fishing, hunting, wood]
        
        let monsters = (0...10).map { Monster(health: Int(10 * pow(2, Double($0)))) }
        
        return GameState(villagers: villagers, territories: territories, monsters: monsters)
    }
}
