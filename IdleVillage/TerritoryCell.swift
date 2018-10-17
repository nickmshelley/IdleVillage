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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(textLabel)
        textLabel.numberOfLines = 0
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.inset(in: contentView, by: 16)
        textLabel.center(in: contentView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with text: String) {
        textLabel.text = text
    }
}
