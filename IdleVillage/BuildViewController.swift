//
//  BuildViewController.swift
//  IdleVillage
//
//  Created by Nick Shelley on 11/15/18.
//  Copyright © 2018 Mine. All rights reserved.
//

import UIKit

class BuildViewController: UITableViewController {
    var available = [TerritoryType]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if GameState.shared.territories.filter({ $0.type == .stone }).count < TerritoryType.stone.maxAllowed {
            available.append(.stone)
        }
//        if !GameState.shared.territories.contains(where: { $0.type == .management }) {
//            available.append(.management)
//        }
//        if !GameState.shared.territories.contains(where: { $0.type == .research }) {
//            available.append(.research)
//        }
        if GameState.shared.territories.filter({ $0.type == .house }).count < TerritoryType.house.maxAllowed {
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
        
        if territoryType.canBuild() {
            territoryType.buildPrice.forEach { GameState.shared.addResource(type: $0.type, amount: -$0.amount) }
            let index = GameState.shared.territories.firstIndex { $0.type == .empty }!
            var territory = Territory(type: territoryType)
            if territoryType == .house {
                territory.assignedVillagers = [GameState.addVillager()]
            }
            GameState.shared.territories[index] = territory
            navigationController?.popViewController(animated: true)
        } else {
            let alert = UIAlertController(title: "Not Enough Resources", message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
}
