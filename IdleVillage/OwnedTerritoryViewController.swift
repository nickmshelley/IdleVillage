//
//  OwnedTerritoryViewController.swift
//  IdleVillage
//
//  Created by Nick Shelley on 10/25/18.
//  Copyright © 2018 Mine. All rights reserved.
//

import UIKit

private extension Territory {
    var upgradePrice: [Resource] {
        let baseUpgradePrice: [Resource]
        switch type {
        case .empty:
            baseUpgradePrice = []
        case .house:
            baseUpgradePrice = type.buildPrice
        case .farming:
            let food = Resource(type: .food, amount: 100)
            let wood = Resource(type: .wood, amount: 100)
            let stone = Resource(type: .stone, amount: 100)
            baseUpgradePrice = [food, wood, stone]
        case .woodChopping:
            let food = Resource(type: .food, amount: 100)
            let wood = Resource(type: .wood, amount: 100)
            let stone = Resource(type: .stone, amount: 100)
            baseUpgradePrice = [food, wood, stone]
        case .stone:
            let food = Resource(type: .food, amount: 100)
            let wood = Resource(type: .wood, amount: 100)
            let stone = Resource(type: .stone, amount: 100)
            baseUpgradePrice = [food, wood, stone]
        case .management:
            baseUpgradePrice = type.buildPrice
        case .research:
            baseUpgradePrice = type.buildPrice
        }
        
        let multiplier = Int(pow(2.0, Double(level)))
        return baseUpgradePrice.map { Resource(type: $0.type, amount: $0.amount * multiplier) }
    }
}

class OwnedTerritoryViewController: UIViewController {
    var territory: Territory
    let titleLabel = UILabel(frame: .zero)
    let levelLabel = UILabel(frame: .zero)
    let occupancyLabel = UILabel(frame: .zero)
    let assignedLabel = UILabel(frame: .zero)
    let assignButton = UIButton(type: .system)
    let upgradeButton = UIButton(type: .system)
    let costLabel = UILabel(frame: .zero)
    
    init(territory: Territory) {
        self.territory = territory
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        view.backgroundColor = .white
        
        [titleLabel, levelLabel, occupancyLabel, assignedLabel, costLabel].forEach { $0.textAlignment = .center }
        
        titleLabel.font = UIFont.systemFont(ofSize: 25)
        titleLabel.text = territory.type.displayString
        updateText()
        assignButton.setTitle("Assign", for: .normal)
        assignButton.addTarget(self, action: #selector(assignTapped), for: .touchUpInside)
        assignButton.isHidden = territory.type == .house
        upgradeButton.setTitle("Upgrade", for: .normal)
        upgradeButton.addTarget(self, action: #selector(upgradeTapped), for: .touchUpInside)
        let stackView = UIStackView(arrangedSubviews: [titleLabel, levelLabel, occupancyLabel, assignedLabel, assignButton, upgradeButton, costLabel])
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
    
    func updateText() {
        occupancyLabel.text = "\(territory.assignedVillagers.count) of \(territory.maxOccupancy) villagers assigned"
        levelLabel.text = "Level \(territory.level)"
        assignedLabel.text = territory.assignedVillagers.joined(separator: ", ")
        assignedLabel.isHidden = territory.assignedVillagers.isEmpty
        let cost = territory.upgradePrice.map { "\($0.type.displayString): \($0.amount)" }.joined(separator: "   ")
        costLabel.text = cost
        
        let hidden = territory.level >= 5
        upgradeButton.isHidden = hidden
        costLabel.isHidden = hidden
    }
    
    @objc func assignTapped() {
        let vc = VillagersTableViewController { villagerName in
            defer { self.navigationController?.popViewController(animated: true) }
            guard !self.territory.assignedVillagers.contains(villagerName), let updated = GameState.assignVillager(villagerName, to: self.territory) else { return }
            
            self.territory = updated
            self.updateText()
        }
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func upgradeTapped() {
        let gameState = GameState.shared!
        
        let hasEnoughResources = !territory.upgradePrice.map { gameState.currentResourceAmount(of: $0.type) >= $0.amount }.contains(false)
        if hasEnoughResources {
            territory.upgradePrice.forEach { GameState.shared.addResource(type: $0.type, amount: -$0.amount) }
            let index = GameState.shared.territories.firstIndex { $0.type == territory.type }!
            var updated = gameState.territories[index]
            updated.level += 1
            GameState.shared.territories[index] = updated
            self.territory = updated
            updateText()
        } else {
            let alert = UIAlertController(title: "Not Enough Resources", message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
}
