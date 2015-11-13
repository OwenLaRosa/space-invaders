//
//  Scoreboard.swift
//  SpaceInvaders
//
//  Created by Owen LaRosa on 11/13/15.
//  Copyright © 2015 Owen LaRosa. All rights reserved.
//

import SpriteKit

class ScoreBoard: SKSpriteNode {
    
    var label = SKLabelNode()
    
    init(size nodeSize: CGSize) {
        super.init(texture: nil, color: SKColor.lightGrayColor(), size: nodeSize)
        
        // configure the label
        label.position = CGPoint(x: 0, y: 0)
        label.color = SKColor.blueColor()
        label.fontName = "Courier"
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureLabel(level: Int?, score: Int?, lives: Int?) {
        label.text = "Level: \(level ?? 0) Score: \(score ?? 0) Lives: \(lives ?? 0)"
    }
    
}
