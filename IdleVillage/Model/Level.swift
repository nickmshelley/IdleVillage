//
//  Level.swift
//  IdleVillage
//
//  Created by Heather Shelley on 10/22/18.
//  Copyright © 2018 Mine. All rights reserved.
//

import Foundation

enum LevelType: String, Codable, CaseIterable {
    case farming
    case woodChopping
    case fighting
    
    var displayString: String {
        switch self {
        case .farming:
            return "Farming"
        case .woodChopping:
            return "Foresting"
        case .fighting:
            return "Fighting"
        }
    }
}

struct Level: Codable {
    let type: LevelType
    var currentLevel: Int
    var maxLevel: Int
    var currentExperience: Double
    var maxExperience: Double
    
    static func initialLevel(of type: LevelType) -> Level {
        return Level(type: type, currentLevel: 1, maxLevel: 5, currentExperience: 0, maxExperience: 10)
    }
}
