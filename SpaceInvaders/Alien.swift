//
//  Alien.swift
//  SpaceInvaders
//
//  Created by Owen LaRosa on 10/31/15.
//  Copyright © 2015 Owen LaRosa. All rights reserved.
//

import SpriteKit

class Alien: SKSpriteNode {
    
    var health = 100
    var points = 0
    
    init() {
        super.init(texture: nil, color: kAlienColor, size: kAlienSize)
        
        name = kAlienName
        addPhysics()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addPhysics() {
        // configure the alien's physics body
        physicsBody = SKPhysicsBody(rectangleOfSize: frame.size)
        physicsBody?.dynamic = true
        physicsBody?.affectedByGravity = false
        physicsBody?.allowsRotation = false
        
        physicsBody?.usesPreciseCollisionDetection = true
        physicsBody?.categoryBitMask = kAlienCategory
        physicsBody?.contactTestBitMask = kBunkerCategory | kEarthCategory
        physicsBody?.collisionBitMask = 0x0
    }
    
    func shoot(duration: Double) {
        let bullet = Bullet(name: kAlienBulletName)
        bullet.position = position
        let target = CGPoint(x: bullet.position.x, y: position.y - 1000) // offscreen
        let fireBullet = SKAction.sequence([SKAction.moveTo(target, duration: duration), SKAction.removeFromParent()])
        
        bullet.physicsBody?.categoryBitMask = kBulletCategory
        bullet.physicsBody?.contactTestBitMask = kShipCategory | kBunkerCategory
        bullet.physicsBody?.collisionBitMask = 0x0
        
        parent?.addChild(bullet)
        bullet.runAction(fireBullet)
    }
    
}
