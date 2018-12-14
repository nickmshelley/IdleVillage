//
//  Territory.swift
//  IdleVillage
//
//  Created by Nick Shelley on 10/17/18.
//  Copyright © 2018 Mine. All rights reserved.
//

import Foundation

enum TerritoryType: String, Codable, CaseIterable {
    case empty
    case house
    case farming
    case woodChopping
    case stone
    case management
    case research
    
    var displayString: String {
        switch self {
        case .empty:
            return "Build"
        case .house:
            return "House"
        case .farming:
            return "Farm"
        case .woodChopping:
            return "Forest"
        case .stone:
            return "Stone Quarry"
        case .management:
            return "Management Tower"
        case .research:
            return "Research Center"
        }
    }
}

struct Territory: Codable {
    let type: TerritoryType
    var level: Int
    var maxLevel: Int
    var maxOccupancy: Int
    var assignedVillagers: [String]
    
    init(type: TerritoryType, level: Int = 1, maxLevel: Int = 5, maxOccupancy: Int = 1, assignedVillagers: [String] = []) {
        self.type = type
        self.level = level
        self.maxLevel = maxLevel
        self.maxOccupancy = maxOccupancy
        self.assignedVillagers = assignedVillagers
    }
}

extension Territory {
    var upgradePrice: [Resource] {
        let baseUpgradePrice: [Resource]
        switch type {
        case .empty:
            baseUpgradePrice = []
        case .house:
            baseUpgradePrice = type.buildPrice
        case .farming:
            let food = Resource(type: .food, amount: 2)
            let wood = Resource(type: .wood, amount: 2)
            let stone = Resource(type: .stone, amount: 2)
            baseUpgradePrice = [food, wood, stone]
        case .woodChopping:
            let food = Resource(type: .food, amount: 100)
            let wood = Resource(type: .wood, amount: 100)
            let stone = Resource(type: .stone, amount: 100)
            baseUpgradePrice = [food, wood, stone]
        case .stone:
            let food = Resource(type: .food, amount: 100)
            let wood = Resource(type: .wood, amount: 100)
            let stone = Resource(type: .stone, amount: 100)
            baseUpgradePrice = [food, wood, stone]
        case .management:
            baseUpgradePrice = type.buildPrice
        case .research:
            baseUpgradePrice = type.buildPrice
        }
        
        let multiplier = Int(pow(2.0, Double(level)))
        return baseUpgradePrice.map { Resource(type: $0.type, amount: $0.amount * multiplier) }
    }
    
    func canUpgrade() -> Bool {
        return level < maxLevel && !upgradePrice.isEmpty && upgradePrice.allSatisfy { GameState.shared.currentResourceAmount(of: $0.type) >= $0.amount }
    }
    
    func canBuild() -> Bool {
        guard type == .empty else { return false }
        
        return TerritoryType.allCases.contains { $0.canBuild() }
    }
}
