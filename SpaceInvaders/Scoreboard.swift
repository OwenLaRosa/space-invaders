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
    var gameData: GameData!
    let padding: CGFloat = 4.0
    
    init(size nodeSize: CGSize) {
        super.init(texture: nil, color: SKColor.lightGrayColor(), size: nodeSize)
        
        // configure the label
        label.fontColor = SKColor.blueColor()
        label.fontName = "Courier"
        label.fontSize = size.height
        label.position = CGPoint(x: 0, y: -size.height/2 + padding)
        addChild(label)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureLabel() {
        label.text = "Level: \(gameData.level) Score: \(gameData.score) Lives: \(gameData.lives)"
        label.position.x = -(size.width/2 - label.frame.size.width/2) + padding
    }
    
}
