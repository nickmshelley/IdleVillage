//
//  BuildViewController.swift
//  IdleVillage
//
//  Created by Nick Shelley on 11/15/18.
//  Copyright © 2018 Mine. All rights reserved.
//

import UIKit

private extension TerritoryType {
    var buildPrice: [Resource] {
        switch self {
        case .empty:
            return []
        case .house:
            return []
        case .farming:
            return []
        case .woodChopping:
            return []
        case .stone:
            let food = Resource(type: .food, amount: 100)
            let wood = Resource(type: .wood, amount: 100)
            return [food, wood]
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
}
