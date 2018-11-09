//
//  Monster.swift
//  IdleVillage
//
//  Created by Heather Shelley on 10/22/18.
//  Copyright © 2018 Mine. All rights reserved.
//

import Foundation

struct Monster: Codable {
    var currentHealth: Int
    let maxHealth: Int
    var assignedVillagers: [String]
    
    init(health: Int) {
        currentHealth = health
        maxHealth = health
        assignedVillagers = []
    }
}
