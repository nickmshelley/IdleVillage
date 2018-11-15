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
    var maxOccupancy: Int
    var assignedVillagers: [String]
}
