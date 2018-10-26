//
//  Monster.swift
//  IdleVillage
//
//  Created by Heather Shelley on 10/22/18.
//  Copyright © 2018 Mine. All rights reserved.
//

import Foundation

struct Monster: Codable {
    let currentHealth: Int
    let maxHealth: Int
    
    init(health: Int) {
        currentHealth = health
        maxHealth = health
    }
}
