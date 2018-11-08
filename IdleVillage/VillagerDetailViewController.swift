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
    var typeByButton = [UIButton: LevelType]()
    
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
        typeByButton = [:]
        stackView.arrangedSubviews.forEach { view in
            stackView.removeArrangedSubview(view)
            view.removeFromSuperview()
        }
        
        stackView.addArrangedSubview(nameLabel)
        LevelType.allCases.forEach { type in
            let level = villager.levels[type] ?? Level.initialLevel(of: type)
            let label = UILabel(frame: .zero)
            label.numberOfLines = 0
            let text = "\(type.displayString): \n\tLevel \(level.currentLevel) of \(level.maxLevel)\n\tExperience \(Int(level.currentExperience)) of \(Int(level.maxExperience))"
            label.text = text
            
            if level.currentExperience == level.maxExperience {
                let button = UIButton(type: .system)
                let title = level.currentLevel == level.maxLevel ? "Transcend" : "Level Up"
                button.setTitle(title, for: .normal)
                button.addTarget(self, action: #selector(levelUpPressed(sender:)), for: .touchUpInside)
                typeByButton[button] = type
                let container = UIView(frame: .zero)
                label.translatesAutoresizingMaskIntoConstraints = false
                button.translatesAutoresizingMaskIntoConstraints = false
                container.addSubview(label)
                container.addSubview(button)
                label.centerYAnchor.constraint(equalTo: container.centerYAnchor).isActive = true
                label.leadingAnchor.constraint(equalTo: container.leadingAnchor).isActive = true
                label.topAnchor.constraint(equalTo: container.topAnchor).isActive = true
                label.bottomAnchor.constraint(equalTo: container.bottomAnchor).isActive = true
                button.centerYAnchor.constraint(equalTo: container.centerYAnchor).isActive = true
                button.trailingAnchor.constraint(equalTo: container.trailingAnchor).isActive = true
                stackView.addArrangedSubview(container)
            } else {
                stackView.addArrangedSubview(label)
            }
            
        }
    }
    
    @objc func levelUpPressed(sender: UIButton) {
        guard let type = typeByButton[sender], let index = GameState.shared.villagers.firstIndex(where: { $0.name == self.villager.name }) else { return print("failed") }
        
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
