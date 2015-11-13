//
//  Bullet.swift
//  SpaceInvaders
//
//  Created by Owen LaRosa on 11/11/15.
//  Copyright © 2015 Owen LaRosa. All rights reserved.
//

import SpriteKit

class Bullet: SKSpriteNode {
    
    var damage = 0
    
    init(name: String) {
        var bulletColor = SKColor()
        if name == kPlayerBulletName {
            bulletColor = kPlayerBulletColor
            damage = kPlayerBulletDamage
        } else if name == kAlienBulletName {
            bulletColor = kAlienBulletColor
            damage = kAlienBulletDamage
        }
        super.init(texture: nil, color: bulletColor, size: kBulletSize)
        self.name = name
        
        addPhysics()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// Add the basic physics properties for all bullets
    func addPhysics() {
        physicsBody = SKPhysicsBody(rectangleOfSize: kBulletSize)
        physicsBody?.dynamic = true
        physicsBody?.affectedByGravity = false
        physicsBody?.allowsRotation = false
    }
    
}
