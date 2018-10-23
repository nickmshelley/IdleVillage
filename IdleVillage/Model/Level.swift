//
//  Level.swift
//  IdleVillage
//
//  Created by Heather Shelley on 10/22/18.
//  Copyright © 2018 Mine. All rights reserved.
//

import Foundation

enum LevelType: String, Codable {
    case farming
    case fishing
    case hunting
    case fighting
}

struct Level: Codable {
    let type: LevelType
    var currentLevel: Int
    var maxLevel: Int
    var currentExperience: Double
    var maxExperience: Double
}
