//
//  TerritoryViewController.swift
//  IdleVillage
//
//  Created by Heather Shelley on 10/13/18.
//  Copyright © 2018 Mine. All rights reserved.
//

import UIKit

class TerritoryViewController: UICollectionViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Territory"
        collectionView.register(TerritoryCell.self, forCellWithReuseIdentifier: "Cell")
        collectionView.backgroundColor = .gray
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! TerritoryCell
        cell.backgroundColor = .white
        cell.configure(with: "Cell \(indexPath.row)")
        return cell
    }
}
