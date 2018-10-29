//
//  Resource.swift
//  IdleVillage
//
//  Created by Nick Shelley on 10/29/18.
//  Copyright © 2018 Mine. All rights reserved.
//

import Foundation

enum ResourceType: String, Codable, CaseIterable {
    case wood
    case stone
}

struct Resource: Codable {
    let type: ResourceType
    var amount: Int
}
