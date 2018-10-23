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
    case fishing
    case hunting
    case woodChopping
}

struct Territory: Codable {
    let type: TerritoryType
    var currentOccupancy: Int
    var maxOccupancy: Int
}
