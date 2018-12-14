//
//  TerritoryCell.swift
//  IdleVillage
//
//  Created by Nick Shelley on 10/17/18.
//  Copyright © 2018 Mine. All rights reserved.
//

import UIKit

class TerritoryCell: UICollectionViewCell {
    let textLabel = UILabel(frame: .zero)
    let actionLabel = UILabel(frame: .zero)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(textLabel)
        contentView.addSubview(actionLabel)
        textLabel.numberOfLines = 0
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.inset(in: contentView, by: 0)
        textLabel.center(in: contentView)
        textLabel.textAlignment = .center
        
        actionLabel.textColor = .red
        actionLabel.textAlignment = .center
        actionLabel.text = "!"
        actionLabel.translatesAutoresizingMaskIntoConstraints = false
        actionLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true
        actionLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -3).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with text: String, isActionAvailable: Bool) {
        textLabel.text = text
        actionLabel.isHidden = !isActionAvailable
    }
}
