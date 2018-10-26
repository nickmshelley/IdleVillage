//
//  MonsterTerritoryViewController.swift
//  IdleVillage
//
//  Created by Nick Shelley on 10/26/18.
//  Copyright © 2018 Mine. All rights reserved.
//

import UIKit

class MonsterTerritoryViewController: UIViewController {
    let monster: Monster
    let titleLabel = UILabel(frame: .zero)
    let healthLabel = UILabel(frame: .zero)
    
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
        healthLabel.text = "Health: \(monster.currentHealth) of \(monster.maxHealth)"
        let stackView = UIStackView(arrangedSubviews: [titleLabel, healthLabel])
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
    }
}
