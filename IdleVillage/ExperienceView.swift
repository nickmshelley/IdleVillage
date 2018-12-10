//
//  ExperienceView.swift
//  IdleVillage
//
//  Created by Nick Shelley on 12/10/18.
//  Copyright © 2018 Mine. All rights reserved.
//

import UIKit

class ExperienceView: UIView {
    private var level: Level
    private let typeLabel = UILabel(frame: .zero)
    private let levelLabel = UILabel(frame: .zero)
    private let progressView = UIProgressView(frame: .zero)
    private let levelUpButton = UIButton(type: .system)
    private let onLevelUp: (LevelType) -> Void
    private var hasInitialized = false
    
    init(level: Level, onLevelUp: @escaping (LevelType) -> Void) {
        self.level = level
        self.onLevelUp = onLevelUp
        super.init(frame: .zero)
        
        backgroundColor = .white
        typeLabel.font = UIFont.boldSystemFont(ofSize: 16)
        let title = level.currentLevel == level.maxLevel ? "Transcend" : "Level Up"
        levelUpButton.setTitle(title, for: .normal)
        levelUpButton.addTarget(self, action: #selector(levelUpPressed), for: .touchUpInside)
        
        [typeLabel, levelLabel, progressView, levelUpButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            addSubview($0)
        }
        [typeLabel, levelLabel, progressView].forEach {
            $0.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
            $0.trailingAnchor.constraint(equalTo: levelUpButton.leadingAnchor, constant: -16).isActive = true
        }
        typeLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true
        progressView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        levelLabel.topAnchor.constraint(equalTo: typeLabel.bottomAnchor, constant: 16).isActive = true
        progressView.topAnchor.constraint(equalTo: levelLabel.bottomAnchor, constant: 16).isActive = true
        levelUpButton.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        levelUpButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        levelUpButton.setContentHuggingPriority(.required, for: .horizontal)
        
        update(with: level)
        hasInitialized = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(with level: Level) {
        guard !hasInitialized || level != self.level else { return }
        
        self.level = level
        typeLabel.text = level.type.displayString
        levelLabel.text = "Level \(level.currentLevel) of \(level.maxLevel)"
        progressView.setProgress(Float(level.currentExperience / level.maxExperience), animated: hasInitialized)
        levelUpButton.isHidden = level.currentExperience < level.maxExperience
    }
    
    @objc func levelUpPressed() {
        onLevelUp(level.type)
    }
}
