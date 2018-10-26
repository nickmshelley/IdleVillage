//
//  VillagerDetailViewController.swift
//  IdleVillage
//
//  Created by Nick Shelley on 10/26/18.
//  Copyright © 2018 Mine. All rights reserved.
//

import UIKit

class VillagerDetailViewController: UIViewController {
    let villager: Villager
    
    init(villager: Villager) {
        self.villager = villager
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        view.backgroundColor = .white
        
        let nameLabel = UILabel(frame: .zero)
        
        nameLabel.font = UIFont.systemFont(ofSize: 25)
        nameLabel.textAlignment = .center
        nameLabel.text = villager.name
        let labels: [UILabel] = LevelType.allCases.map { type in
            let level = villager.levels[type]
            let label = UILabel(frame: .zero)
            label.numberOfLines = 0
            let currentLevel = level?.currentLevel ?? 0
            let maxLevel = level?.maxLevel ?? 5
            let currentExperience = Int(level?.currentExperience ?? 0)
            let maxExperience = Int(level?.maxExperience ?? 10)
            let text = "\(type.displayString): \n\tLevel \(currentLevel) of \(maxLevel)\n\tExperience \(currentExperience) of \(maxExperience)"
            label.text = text
            return label
        }
        let stackView = UIStackView(arrangedSubviews: [nameLabel] + labels)
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
