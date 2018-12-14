//
//  TerritoryViewController.swift
//  IdleVillage
//
//  Created by Heather Shelley on 10/13/18.
//  Copyright © 2018 Mine. All rights reserved.
//

import UIKit

private enum SectionType {
    case owned
    case monster
}

private struct Section {
    let title: String
    let type: SectionType
    let items: [Row]
}

private struct Row {
    let title: String
    let isActionAvailable: Bool
}

class TerritoriesViewController: UICollectionViewController {
    private var sections = [Section]()
    private var territories = [Territory]()
    private var monsters = [Monster]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Territory"
        collectionView.register(TerritoryCell.self, forCellWithReuseIdentifier: "Cell")
        collectionView.backgroundColor = .gray
        
        update()
        
        NotificationCenter.default.addObserver(self, selector: #selector(update), name: GameState.villagersAssignedNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(update), name: GameEngine.gameUpdatedNotification, object: nil)
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sections[section].items.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! TerritoryCell
        cell.backgroundColor = .white
        let row = sections[indexPath.section].items[indexPath.row]
        cell.configure(with: row.title, isActionAvailable: row.isActionAvailable)
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch sections[indexPath.section].type {
        case .owned:
            let territory = territories[indexPath.item]
            switch territory.type {
            case .empty:
                navigationController?.pushViewController(BuildViewController(), animated: true)
            default:
                navigationController?.pushViewController(OwnedTerritoryViewController(index: indexPath.item), animated: true)
            }
        case .monster:
            navigationController?.pushViewController(MonsterTerritoryViewController(monster: monsters[indexPath.item]), animated: true)
        }
    }
    
    @objc func update() {
        territories = GameState.shared.territories
        self.monsters = GameState.shared.monsters.filter { $0.currentHealth > 0 }
        
        let owned: [Row] = territories.map { territory in
            let title: String = territory.type.displayString + "\n(\(territory.assignedVillagers.count) of \(territory.maxOccupancy))"
            let hasAction = territory.canUpgrade() || territory.canBuild()
            return Row(title: title, isActionAvailable: hasAction)
        }
        let ownedSection = Section(title: "Owned Territories", type: .owned, items: owned)
        
        let monsters = self.monsters.map { Row(title: "Monster\n(\($0.currentHealth) of \($0.maxHealth))", isActionAvailable: false) }
        let monsterSection = Section(title: "Monster Territories", type: .monster, items: monsters)
        
        sections = [ownedSection, monsterSection]
        
        collectionView.reloadData()
    }
}
