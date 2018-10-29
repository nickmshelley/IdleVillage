//
//  ResourcesViewController.swift
//  IdleVillage
//
//  Created by Nick Shelley on 10/29/18.
//  Copyright © 2018 Mine. All rights reserved.
//

import UIKit

class ResourcesViewController: UIViewController {
    let label = UILabel(frame: .zero)
    let child: UIViewController
    
    init(child: UIViewController) {
        self.child = child
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addChild(child)
        
        view.backgroundColor = .white
        label.text = resourcesString()
        label.numberOfLines = 0
        view.addSubview(label)
        view.addSubview(child.view)
        label.translatesAutoresizingMaskIntoConstraints = false
        child.view.translatesAutoresizingMaskIntoConstraints = false
        
        label.safeAreaLayoutGuide.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16).isActive = true
        label.safeAreaLayoutGuide.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        label.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16).isActive = true
        
        child.view.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 16).isActive = true
        child.view.safeAreaLayoutGuide.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 0).isActive = true
        child.view.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 0).isActive = true
        child.view.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true

        child.didMove(toParent: self)
        
        title = child.title
    }
    
    private func resourcesString() -> String {
        let resources = GameState.shared.resources
        let strings: [String] = ResourceType.allCases.map { type in
            let amount = resources[type]?.amount ?? 0
            return "\(type.displayString): \(amount)"
        }
        
        return strings.joined(separator: "   ")
    }
}
