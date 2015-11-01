//
//  Bunker.swift
//  SpaceInvaders
//
//  Created by Owen LaRosa on 11/1/15.
//  Copyright © 2015 Owen LaRosa. All rights reserved.
//

import SpriteKit

class BunkerNode: SKSpriteNode {
    
    init() {
        super.init(texture: nil, color: kBunkerColor, size: kBunkerSize)
        
        name = kBunkerName
        addPhysics()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addPhysics() {
        // configure the bunker's physics body
        physicsBody = SKPhysicsBody(rectangleOfSize: frame.size)
        physicsBody?.dynamic = true
        physicsBody?.affectedByGravity = false
        physicsBody?.allowsRotation = false
        
        physicsBody?.categoryBitMask = kBunkerCategory
        physicsBody?.contactTestBitMask = 0x0
        physicsBody?.collisionBitMask = 0x0
    }
    
}
