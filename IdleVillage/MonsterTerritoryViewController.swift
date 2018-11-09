//
//  MonsterTerritoryViewController.swift
//  IdleVillage
//
//  Created by Nick Shelley on 10/26/18.
//  Copyright © 2018 Mine. All rights reserved.
//

import UIKit

class MonsterTerritoryViewController: UIViewController {
    var monster: Monster
    let titleLabel = UILabel(frame: .zero)
    let healthLabel = UILabel(frame: .zero)
    let assignedLabel = UILabel(frame: .zero)
    let assignButton = UIButton(type: .system)
    
    init(monster: Monster) {
        self.monster = monster
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        view.backgroundColor = .white
        
        titleLabel.font = UIFont.systemFont(ofSize: 25)
        titleLabel.textAlignment = .center
        titleLabel.text = "Monster"
        healthLabel.textAlignment = .center
        assignedLabel.textAlignment = .center
        assignedLabel.numberOfLines = 0
        updateText()
        assignButton.setTitle("Assign", for: .normal)
        assignButton.addTarget(self, action: #selector(assignTapped), for: .touchUpInside)
        let stackView = UIStackView(arrangedSubviews: [titleLabel, healthLabel, assignedLabel, assignButton])
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.distribution = .equalSpacing
        stackView.alignment = .fill
        
        view.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16).isActive = true
        stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16).isActive = true
        stackView.bottomAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 16).isActive = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(gameUpdated), name: GameEngine.gameUpdatedNotification, object: nil)
    }
    
    @objc func gameUpdated() {
        monster = GameState.shared.monsters.first { $0.maxHealth == self.monster.maxHealth }!
        updateText()
    }
    
    func updateText() {
        healthLabel.text = "Health: \(monster.currentHealth) of \(monster.maxHealth)"
        assignedLabel.text = "Assigned: " + monster.assignedVillagers.joined(separator: ", ")
        assignedLabel.isHidden = monster.assignedVillagers.isEmpty
    }
    
    @objc func assignTapped() {
        let vc = VillagersTableViewController { villagerName in
            defer { self.navigationController?.popViewController(animated: true) }
            guard !self.monster.assignedVillagers.contains(villagerName), let updated = GameState.assignVillager(villagerName, to: self.monster) else { return }
            
            self.monster = updated
            self.updateText()
        }
        
        navigationController?.pushViewController(vc, animated: true)
    }
}
