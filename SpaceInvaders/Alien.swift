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
        
        if position.y - size.height/2.0 - kAlienMovementY <= kEarth {
            bullet.damage = 0
        }
        
        parent?.addChild(bullet)
        bullet.runAction(fireBullet)
    }
    
}

class BossAlien: Alien {
    
    // Specifies whether or not the boss has an animation effect
    var animated = false
    var shootingInterval = 0.0
    
    init(type: BossType) {
        super.init()
        name = kBossAlienName
        size = kBossAlienSize
        // set the appropriate properties
        let info = bossInfo[type.rawValue]
        health = info.health
        points = info.points
        shootingInterval = info.shootingInterval
        animated = info.animated
        if animated {
            startAnimation()
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func startAnimation() {
        let firstAnimation = SKAction.colorizeWithColor(SKColor.cyanColor(), colorBlendFactor: 0.0, duration: 1.5)
        let secondAnimation = SKAction.colorizeWithColor(SKColor.whiteColor(), colorBlendFactor: 0.0, duration: 1.5)
        runAction(SKAction.repeatActionForever(SKAction.sequence([firstAnimation, secondAnimation])))
    }
    
}
