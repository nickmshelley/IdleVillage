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
    let selectionHandler: ((String) -> Void)?
    
    init(selectionHandler: ((String) -> Void)? = nil) {
        self.selectionHandler = selectionHandler
        super.init(style: .plain)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let selectionHandler = selectionHandler {
            selectionHandler(villagers[indexPath.row].name)
        } else {
            navigationController?.pushViewController(VillagerDetailViewController(villager: villagers[indexPath.row]), animated: true)
        }
    }
}
