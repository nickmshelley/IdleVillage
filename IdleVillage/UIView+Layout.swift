//
//  UIView+Layout.swift
//  IdleVillage
//
//  Created by Nick Shelley on 10/17/18.
//  Copyright © 2018 Mine. All rights reserved.
//

import UIKit

extension UIView {
    func center(in view: UIView) {
        centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    func inset(in view: UIView, by amount: CGFloat) {
        topAnchor.constraint(greaterThanOrEqualTo: view.topAnchor, constant: amount)
        leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: amount)
        trailingAnchor.constraint(greaterThanOrEqualTo: view.trailingAnchor, constant: amount)
        bottomAnchor.constraint(greaterThanOrEqualTo: view.bottomAnchor, constant: amount)
    }
}
