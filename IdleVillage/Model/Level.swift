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
    case fishing
    case hunting
    case fighting
    
    var displayString: String {
        switch self {
        case .farming:
            return "Farming"
        case .fishing:
            return "Fishing"
        case .hunting:
            return "Hunting"
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
}
