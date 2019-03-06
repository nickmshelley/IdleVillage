//
//  Resource.swift
//  IdleVillage
//
//  Created by Nick Shelley on 10/29/18.
//  Copyright © 2018 Mine. All rights reserved.
//

import Foundation

enum ResourceType: String, Codable, CaseIterable {
    case food
    case wood
    case stone
    case research
    
    var displayString: String {
        switch self {
        case .food:
            return "Food"
        case .wood:
            return "Wood"
        case .stone:
            return "Stone"
        case .research:
            return "Research"
        }
    }
}

struct Resource: Codable {
    let type: ResourceType
    var amount: Int
}
