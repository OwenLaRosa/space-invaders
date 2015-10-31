//
//  Player.swift
//  SpaceInvaders
//
//  Created by Owen LaRosa on 10/31/15.
//  Copyright © 2015 Owen LaRosa. All rights reserved.
//

import SpriteKit

class Player: SKSpriteNode {
    
    init() {
        super.init(texture: nil, color: kShipColor, size: kShipSize)
        
        name = kShipName
        addPhysics()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addPhysics() {
        print("addPhysics")
        // configure the player's physics body
        physicsBody = SKPhysicsBody(rectangleOfSize: frame.size)
        physicsBody?.dynamic = true
        physicsBody?.affectedByGravity = false
        physicsBody?.mass = 0.01
        physicsBody?.allowsRotation = false
        physicsBody?.usesPreciseCollisionDetection = true
        
        physicsBody?.categoryBitMask = kShipCategory
        physicsBody?.contactTestBitMask = 0x0
        physicsBody?.collisionBitMask = 0x0
    }
    
    func shoot() {
        let bullet = SKSpriteNode(color: kPlayerBulletColor, size: kBulletSize)
        bullet.position = position
        let target = CGPoint(x: bullet.position.x, y: bullet.position.y + 1000) // offscreen
        let fireBullet = SKAction.sequence([SKAction.moveTo(target, duration: 2.5), SKAction.removeFromParent()])
        
        bullet.physicsBody = SKPhysicsBody(rectangleOfSize: kBulletSize)
        bullet.physicsBody?.dynamic = true
        bullet.physicsBody?.affectedByGravity = false
        physicsBody?.allowsRotation = false
        //bullet.physicsBody?.usesPreciseCollisionDetection = true
        bullet.physicsBody?.categoryBitMask = kBulletCategory
        bullet.physicsBody?.contactTestBitMask = kAlienCategory
        bullet.physicsBody?.collisionBitMask = 0x0
        
        parent?.addChild(bullet)
        bullet.runAction(fireBullet)
    }
    
}