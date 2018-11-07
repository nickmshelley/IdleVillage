//
//  VillagerDetailViewController.swift
//  IdleVillage
//
//  Created by Nick Shelley on 10/26/18.
//  Copyright © 2018 Mine. All rights reserved.
//

import UIKit

class VillagerDetailViewController: UIViewController {
    var villager: Villager
    let stackView = UIStackView(frame: .zero)
    let nameLabel = UILabel(frame: .zero)
    
    init(villager: Villager) {
        self.villager = villager
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        view.backgroundColor = .white
        
        nameLabel.font = UIFont.systemFont(ofSize: 25)
        nameLabel.textAlignment = .center
        nameLabel.text = villager.name
        updateText()
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
    
    private func updateText() {
        stackView.arrangedSubviews.forEach { view in
            stackView.removeArrangedSubview(view)
            view.removeFromSuperview()
        }
        
        stackView.addArrangedSubview(nameLabel)
        LevelType.allCases.forEach { type in
            let level = villager.levels[type] ?? Level.initialLevel(of: type)
            let label = UILabel(frame: .zero)
            label.numberOfLines = 0
            let text = "\(type.displayString): \n\tLevel \(level.currentLevel) of \(level.maxLevel)\n\tExperience \(level.currentExperience) of \(level.maxExperience)"
            label.text = text
            stackView.addArrangedSubview(label)
        }
    }
    
    @objc func gameUpdated() {
        guard let villager = GameState.shared.villagers.first(where: { $0.name == villager.name }) else { return }
        
        self.villager = villager
        updateText()
    }
}
