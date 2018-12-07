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
    private static let namePool = ["Clare", "Cole", "Emily", "Braden", "Katelyn", "Ella", "Eloise", "Penny", "Jon", "Ryan"]
    static let villagersAssignedNotification = Notification.Name("VillagerAssigned")
    
    var resources: [ResourceType: Resource]
    var villagers: [Villager]
    var territories: [Territory]
    var monsters: [Monster]
    
    static func addVillager() -> String {
        let existingNames = Set(GameState.shared.villagers.map { $0.name })
        let name = GameState.namePool.filter { !existingNames.contains($0) }.randomElement()!
        let newVillager = Villager(name: name, levels: [:])
        GameState.shared.villagers.append(newVillager)
        return name
    }
    
    func currentResourceAmount(of type: ResourceType) -> Int {
        return resources[type]?.amount ?? 0
    }
    
    mutating func addResource(type: ResourceType, amount: Int) {
        resources[type] = Resource(type: type, amount: currentResourceAmount(of: type) + amount)
    }
    
    static func filePath() -> String {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last!.appendingPathComponent("UserData.sqlite").path
    }
    
    static func makeInitial() -> GameState {
        let debug = false
        
        let villagerNames = [namePool.randomElement()!]
        let villagers = villagerNames.map { Villager(name: $0, levels: [:]) }
        
        let house = Territory(type: .house, assignedVillagers: villagerNames)
        let farming = Territory(type: .farming)
        let wood = Territory(type: .woodChopping)
        var territories = [house, farming, wood]
        if debug {
            territories.append(contentsOf: [Territory(type: .empty), Territory(type: .empty), Territory(type: .empty), Territory(type: .empty)])
        }
        
        let monsters = (0...10).map { Monster(health: Int(100 * pow(2, Double($0)))) }
        
        let resources: [ResourceType: Resource] = debug ? [.food: Resource(type: .food, amount: 1000000), .wood: Resource(type: .wood, amount: 1000000), .stone: Resource(type: .stone, amount: 1000000)] : [:]
        
        return GameState(resources: resources, villagers: villagers, territories: territories, monsters: monsters)
    }
    
    static func assignVillager(_ villagerName: String, to territory: Territory) -> Territory? {
        defer { NotificationCenter.default.post(name: GameState.villagersAssignedNotification, object: nil) }
        
        unassignVillager(villagerName)
        
        if let index = GameState.shared.territories.firstIndex(where: { $0.type == territory.type }) {
            var updated = GameState.shared.territories[index]
            updated.assignedVillagers.append(villagerName)
            if updated.assignedVillagers.count > updated.maxOccupancy {
                updated.assignedVillagers.removeFirst()
            }
            GameState.shared.territories[index] = updated
            
            return updated
        }
        
        return nil
    }
    
    static func assignVillager(_ villagerName: String, to monster: Monster) -> Monster? {
        defer { NotificationCenter.default.post(name: GameState.villagersAssignedNotification, object: nil) }
        
        unassignVillager(villagerName)
        
        if let index = GameState.shared.monsters.firstIndex(where: { $0.maxHealth == monster.maxHealth }) {
            var updated = GameState.shared.monsters[index]
            updated.assignedVillagers.append(villagerName)
            GameState.shared.monsters[index] = updated
            
            return updated
        }
        
        return nil
    }
    
    private static func unassignVillager(_ villagerName: String) {
        if let index = GameState.shared.territories.firstIndex(where: { $0.assignedVillagers.contains(villagerName) && $0.type != .house }) {
            var updated = GameState.shared.territories[index]
            updated.assignedVillagers.remove(at: updated.assignedVillagers.firstIndex(where: { $0 == villagerName })!)
            GameState.shared.territories[index] = updated
        }
        
        if let index = GameState.shared.monsters.firstIndex(where: { $0.assignedVillagers.contains(villagerName) }) {
            var updated = GameState.shared.monsters[index]
            updated.assignedVillagers.remove(at: updated.assignedVillagers.firstIndex(where: { $0 == villagerName })!)
            GameState.shared.monsters[index] = updated
        }
    }
}
