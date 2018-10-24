//
//  VillagersTableViewController.swift
//  IdleVillage
//
//  Created by Nick Shelley on 10/24/18.
//  Copyright © 2018 Mine. All rights reserved.
//

import UIKit

class VillagersTableViewController: UITableViewController {
    var villagers = [Villager]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Villagers"
        villagers = GameState.shared.villagers
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return villagers.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = villagers[indexPath.row].name
        return cell
    }
}
