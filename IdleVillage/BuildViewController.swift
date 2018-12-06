//
//  BuildViewController.swift
//  IdleVillage
//
//  Created by Nick Shelley on 11/15/18.
//  Copyright © 2018 Mine. All rights reserved.
//

import UIKit

extension TerritoryType {
    var buildPrice: [Resource] {
        switch self {
        case .empty:
            return []
        case .house:
            let food = Resource(type: .food, amount: 500)
            let wood = Resource(type: .wood, amount: 500)
            let stone = Resource(type: .stone, amount: 500)
            return [food, wood, stone]
        case .farming:
            return []
        case .woodChopping:
            return []
        case .stone:
            let food = Resource(type: .food, amount: 100)
            let wood = Resource(type: .wood, amount: 100)
            return [food, wood]
        case .management:
            let food = Resource(type: .food, amount: 300)
            let wood = Resource(type: .wood, amount: 300)
            let stone = Resource(type: .stone, amount: 300)
            return [food, wood, stone]
        case .research:
            let food = Resource(type: .food, amount: 200)
            let wood = Resource(type: .wood, amount: 200)
            let stone = Resource(type: .stone, amount: 200)
            return [food, wood, stone]
        }
    }
}

class BuildViewController: UITableViewController {
    var available = [TerritoryType]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if !GameState.shared.territories.contains(where: { $0.type == .stone }) {
            available.append(.stone)
        }
        if !GameState.shared.territories.contains(where: { $0.type == .management }) {
            available.append(.management)
        }
        if !GameState.shared.territories.contains(where: { $0.type == .research }) {
            available.append(.research)
        }
        if GameState.shared.territories.filter({ $0.type == .house }).count < 2 {
            available.append(.house)
        }
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return available.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let type = available[indexPath.row]
        let title = type.displayString
        let cost = type.buildPrice.map { "\($0.type.displayString): \($0.amount)" }.joined(separator: "   ")
        cell.textLabel?.text = "\(title) (\(cost))"
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let territoryType = available[indexPath.row]
        let gameState = GameState.shared!
        
        let hasEnoughResources = !territoryType.buildPrice.map { gameState.currentResourceAmount(of: $0.type) >= $0.amount }.contains(false)
        if hasEnoughResources {
            territoryType.buildPrice.forEach { GameState.shared.addResource(type: $0.type, amount: -$0.amount) }
            let index = GameState.shared.territories.firstIndex { $0.type == .empty }!
            GameState.shared.territories[index] = Territory(type: territoryType)
            navigationController?.popViewController(animated: true)
        } else {
            let alert = UIAlertController(title: "Not Enough Resources", message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
}
