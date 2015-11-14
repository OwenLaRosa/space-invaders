//
//  Earth.swift
//  SpaceInvaders
//
//  Created by Owen LaRosa on 11/14/15.
//  Copyright © 2015 Owen LaRosa. All rights reserved.
//

import SpriteKit

class Earth: SKSpriteNode {
    
    init(width: CGFloat) {
        super.init(texture: nil, color: SKColor.greenColor(), size: CGSize(width: width, height: kEarthHeight))
        
        addPhysics()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addPhysics() {
        physicsBody = SKPhysicsBody(rectangleOfSize: frame.size)
        physicsBody?.dynamic = true
        physicsBody?.affectedByGravity = false
        physicsBody?.allowsRotation = false
        physicsBody?.usesPreciseCollisionDetection = true
        
        physicsBody?.categoryBitMask = kEarthCategory
        physicsBody?.contactTestBitMask = 0x0
        physicsBody?.collisionBitMask = 0x0
    }
    
}
