//
//  OwnedTerritoryViewController.swift
//  IdleVillage
//
//  Created by Nick Shelley on 10/25/18.
//  Copyright © 2018 Mine. All rights reserved.
//

import UIKit

class OwnedTerritoryViewController: UIViewController {
    var territory: Territory
    let titleLabel = UILabel(frame: .zero)
    let occupancyLabel = UILabel(frame: .zero)
    let assignedLabel = UILabel(frame: .zero)
    let assignButton = UIButton(type: .system)
    
    init(territory: Territory) {
        self.territory = territory
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        view.backgroundColor = .white
        
        titleLabel.font = UIFont.systemFont(ofSize: 25)
        titleLabel.textAlignment = .center
        titleLabel.text = territory.type.displayString
        occupancyLabel.textAlignment = .center
        assignedLabel.textAlignment = .center
        updateText()
        assignButton.setTitle("Assign", for: .normal)
        assignButton.addTarget(self, action: #selector(assignTapped), for: .touchUpInside)
        let stackView = UIStackView(arrangedSubviews: [titleLabel, occupancyLabel, assignedLabel, assignButton])
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
        assignedLabel.text = territory.assignedVillagers.joined(separator: ", ")
        assignedLabel.isHidden = territory.assignedVillagers.isEmpty
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
}
