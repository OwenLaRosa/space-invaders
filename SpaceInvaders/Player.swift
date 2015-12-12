//
//  Player.swift
//  SpaceInvaders
//
//  Created by Owen LaRosa on 10/31/15.
//  Copyright © 2015 Owen LaRosa. All rights reserved.
//

import SpriteKit

class Player: SKSpriteNode {
    
    var health = 100
    
    init() {
        super.init(texture: nil, color: kShipColor, size: kShipSize)
        
        name = kShipName
        addPhysics()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addPhysics() {
        // configure the player's physics body
        
        // specify size and position for the physics body.
        // will be a "line" on the top edge of the player
        let physicsSize = CGSize(width: size.width, height: 1)
        let physicsPosition = CGPoint(x: 0, y: size.height/2 - 1) // -1: take height into account
        physicsBody = SKPhysicsBody(rectangleOfSize: physicsSize, center: physicsPosition)
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
        let bullet = Bullet(name: kPlayerBulletName)
        bullet.position = position
        let target = CGPoint(x: bullet.position.x, y: kUniversalScreenHeight) // top of screen
        let fireBullet = SKAction.sequence([SKAction.moveTo(target, duration: 1.5), SKAction.removeFromParent()])
        
        bullet.physicsBody?.categoryBitMask = kBulletCategory
        bullet.physicsBody?.contactTestBitMask = kAlienCategory | kBunkerCategory
        bullet.physicsBody?.collisionBitMask = 0x0
        
        parent?.addChild(bullet)
        bullet.runAction(fireBullet)
    }
    
}
