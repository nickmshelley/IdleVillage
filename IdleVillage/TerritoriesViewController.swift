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
    let items: [String]
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
        cell.configure(with: sections[indexPath.section].items[indexPath.row])
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
        
        let owned = territories.map { $0.type.displayString + "\n(\($0.assignedVillagers.count) of \($0.maxOccupancy))" }
        let ownedSection = Section(title: "Owned Territories", type: .owned, items: owned)
        
        let monsters = self.monsters.map { "Monster\n(\($0.currentHealth) of \($0.maxHealth))" }
        let monsterSection = Section(title: "Monster Territories", type: .monster, items: monsters)
        
        sections = [ownedSection, monsterSection]
        
        collectionView.reloadData()
    }
}
