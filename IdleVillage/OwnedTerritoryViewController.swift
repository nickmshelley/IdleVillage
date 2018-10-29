//
//  OwnedTerritoryViewController.swift
//  IdleVillage
//
//  Created by Nick Shelley on 10/25/18.
//  Copyright © 2018 Mine. All rights reserved.
//

import UIKit

class OwnedTerritoryViewController: UIViewController {
    let territory: Territory
    let titleLabel = UILabel(frame: .zero)
    let occupancyLabel = UILabel(frame: .zero)
    let assignedLabel = UILabel(frame: .zero)
    
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
        occupancyLabel.text = "\(territory.assignedVillagers.count) of \(territory.maxOccupancy) villagers assigned"
        assignedLabel.textAlignment = .center
        assignedLabel.text = territory.assignedVillagers.joined(separator: ", ")
        assignedLabel.isHidden = territory.assignedVillagers.isEmpty
        let stackView = UIStackView(arrangedSubviews: [titleLabel, occupancyLabel, assignedLabel])
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
