//
//  TerritoryType.swift
//  IdleVillage
//
//  Created by Heather Shelley on 12/14/18.
//  Copyright © 2018 Mine. All rights reserved.
//

import Foundation

enum TerritoryType: String, Codable, CaseIterable {
    case empty
    case house
    case farming
    case woodChopping
    case stone
    //    case management
    //    case research
    
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
            //        case .management:
            //            return "Management Tower"
            //        case .research:
            //            return "Research Center"
        }
    }
}

extension TerritoryType {
    var buildPrice: [Resource] {
        switch self {
        case .empty:
            return []
        case .house:
            let food = Resource(type: .food, amount: 100)
            let wood = Resource(type: .wood, amount: 100)
            let stone = Resource(type: .stone, amount: 100)
            return [food, wood, stone]
        case .farming:
            return []
        case .woodChopping:
            return []
        case .stone:
            let food = Resource(type: .food, amount: 100)
            let wood = Resource(type: .wood, amount: 100)
            return [food, wood]
            //        case .management:
            //            let food = Resource(type: .food, amount: 300)
            //            let wood = Resource(type: .wood, amount: 300)
            //            let stone = Resource(type: .stone, amount: 300)
            //            return [food, wood, stone]
            //        case .research:
            //            let food = Resource(type: .food, amount: 200)
            //            let wood = Resource(type: .wood, amount: 200)
            //            let stone = Resource(type: .stone, amount: 200)
            //            return [food, wood, stone]
        }
    }
    
    func canBuild() -> Bool {
        return !buildPrice.isEmpty && buildPrice.allSatisfy { GameState.shared.currentResourceAmount(of: $0.type) >= $0.amount }
    }
    
    var maxAllowed: Int {
        switch self {case .empty:
            return 0
        case .house:
            return 2
        case .farming:
            return 1
        case .woodChopping:
            return 1
        case .stone:
            return 1
        }
    }
}
