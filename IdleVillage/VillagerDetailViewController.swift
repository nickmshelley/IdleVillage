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
    var viewByType = [LevelType: ExperienceView]()
    
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
        nameLabel.text = villager.name + " (\(villager.assignedTerritory))"
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.distribution = .equalSpacing
        stackView.alignment = .fill
        
        stackView.addArrangedSubview(nameLabel)
        LevelType.allCases.forEach { type in
            let level = villager.levels[type] ?? Level.initialLevel(of: type)
            let view = ExperienceView(level: level, onLevelUp: { [weak self] in self?.levelUp(type: $0) })
            stackView.addArrangedSubview(view)
            viewByType[type] = view
        }
        
        view.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16).isActive = true
        stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16).isActive = true
        stackView.bottomAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 16).isActive = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(gameUpdated), name: GameEngine.gameUpdatedNotification, object: nil)
    }
    
    private func updateText() {
        nameLabel.text = villager.name + " (\(villager.assignedTerritory))"
        LevelType.allCases.forEach { type in
            let level = villager.levels[type] ?? Level.initialLevel(of: type)
            viewByType[type]?.update(with: level)
        }
    }
    
    func levelUp(type: LevelType) {
        guard let index = GameState.shared.villagers.firstIndex(where: { $0.name == self.villager.name }) else { return print("failed") }
        
        var villager = GameState.shared.villagers[index]
        villager.levelUp(type: type)
        
        GameState.shared.villagers[index] = villager
        NotificationCenter.default.post(name: GameEngine.gameUpdatedNotification, object: nil)
    }
    
    @objc func gameUpdated() {
        guard let villager = GameState.shared.villagers.first(where: { $0.name == villager.name }) else { return }
        
        self.villager = villager
        updateText()
    }
}
