//
//  Territory.swift
//  IdleVillage
//
//  Created by Nick Shelley on 10/17/18.
//  Copyright © 2018 Mine. All rights reserved.
//

import Foundation

enum TerritoryType: String, Codable {
    case empty
    case house
    case farming
    case woodChopping
    case stone
    
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
        }
    }
}

struct Territory: Codable {
    let type: TerritoryType
    var level: Int
    var maxOccupancy: Int
    var assignedVillagers: [String]
    
    init(type: TerritoryType, level: Int = 1, maxOccupancy: Int = 1, assignedVillagers: [String] = []) {
        self.type = type
        self.level = level
        self.maxOccupancy = maxOccupancy
        self.assignedVillagers = assignedVillagers
    }
}
