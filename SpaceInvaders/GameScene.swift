//
//  GameScene.swift
//  SpaceInvaders
//
//  Created by Owen LaRosa on 10/26/15.
//  Copyright (c) 2015 Owen LaRosa. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    // MARK: - Game Arena
    
    var minLocationX: CGFloat!
    var maxLocationX: CGFloat!
    
    // MARK: - GameProperties
    var isFirstUpdate = true
    var aliensLastMoved: CFTimeInterval = 1.0
    var playerLastShot = NSDate()
    var aliensLastShot: CFTimeInterval = 0.5
    
    // MARK: - Player Properties
    var ship: Player!
    var playerShootSpeed = 1.0
    
    // MARK: - Alien properties
    var alienMoveSpeed = 1.0
    var alienMoveDirection: MoveDirection = .Right
    var alienShootSpeed = 1.5
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        configureScreen()
        
        // add physics body to the game arena
        physicsWorld.contactDelegate = self
        
        // Create game entities
        addPlayerShip()
        addAliens()
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /* Called when a touch begins */
        
        if abs(playerLastShot.timeIntervalSinceNow) >= playerShootSpeed {
            playerLastShot = NSDate()
            ship.shoot()
        }
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        
        // wait for the game to start to perform updates
        if isFirstUpdate {
            aliensLastMoved += currentTime
            aliensLastShot += currentTime
            isFirstUpdate = false
        }
        
        // handle alien bullets
        if (currentTime - alienShootSpeed) >= aliensLastShot {
            if let nearestAlien = getNearestAlien() {
                aliensLastShot = currentTime
                nearestAlien.shoot()
            }
        }
        
        // handle alien movement
        if (currentTime - alienMoveSpeed) >=
            aliensLastMoved {
                // and update to the most recent time
                aliensLastMoved = currentTime
                moveAliens()
        }
    }
    
    /// Configure the screen to match device size
    func configureScreen() {
        let screenSize = UIScreen.mainScreen().bounds.size
        size.width = screenSize.width
        size.height = screenSize.height
        backgroundColor = SKColor.blackColor()
        
        // set up consistent game arena for all device screens
        minLocationX = getAliensOrigin().x - CGFloat(kAlienMovementX * 8) - 1.0 // number of movements on 5, 5s
        maxLocationX = abs(size.width - getAliensOrigin().x) + CGFloat(kAlienMovementX * 8) + 1.0
        print(minLocationX)
        print(maxLocationX)
    }
    
    /// Add the player's ship to the game
    func addPlayerShip() {
        ship = Player()
        ship.position = CGPoint(x: size.width/2, y: ship.size.height/2)
        addChild(ship)
    }
    
    /// Add 11x5 grid of aliens to the game
    func addAliens() {
        let aliensOrigin = getAliensOrigin()
        
        var nextYOrigin = aliensOrigin.y
        for _ in 1...kAlienRows {
            var nextXOrigin = aliensOrigin.x
            for _ in 1...kAlienColumns {
                let alien = Alien()
                alien.position = CGPoint(x: nextXOrigin, y: nextYOrigin)
                addChild(alien)
                nextXOrigin += kAlienSize.width + CGFloat(kAlienHorizontalSpacing)
            }
            nextYOrigin -= kAlienSize.height + CGFloat(kAlienHorizontalSpacing)
        }
    }
    
    /// Returns starting coordinate for placing aliens
    func getAliensOrigin() -> CGPoint {
        // width and height of entire alien grid, including spacing
        let totalWidth = kAlienColumns * Int(kAlienSize.width) + (kAlienColumns - 1) * kAlienHorizontalSpacing
        let totalHeight = kAlienRows * Int(kAlienSize.height) + (kAlienRows - 1) * kAlienVerticalSpacing
        
        let distanceFromEarth = kEarth + totalHeight
        
        let xOrigin = size.width/2.0 - CGFloat(totalWidth/2) + kAlienSize.width/2.0
        let yOrigin = CGFloat(totalHeight)*2.3 // magic number that works well on 5, 5s screen
        
        return CGPoint(x: xOrigin, y: yOrigin)
    }
    
    /// Move aliens with the standard movement pattern
    func moveAliens() {
        var shouldChangeDirection = false
        // determine if the next move would put an alien offscreen
        enumerateChildNodesWithName(kAlienName) {alien, stop in
            if self.alienMoveDirection == .Right && alien.position.x + kAlienMovementX > self.maxLocationX {
                shouldChangeDirection = true
                return
            } else if self.alienMoveDirection == .Left && alien.position.x - kAlienMovementX < self.minLocationX {
                shouldChangeDirection = true
                return
            }
        }
        // if needed, change the movement direction
        if shouldChangeDirection {
            if alienMoveDirection == .Right {
                alienMoveDirection = .Left
            } else {
                alienMoveDirection = .Right
            }
        }
        enumerateChildNodesWithName(kAlienName) {alien, stop in
            // move the aliens down if needed
            if shouldChangeDirection {
                alien.position.y -= kAlienMovementY
                return
            }
            // otherwise, move in the appropriate direction
            if self.alienMoveDirection == .Right  {
                alien.position.x += kAlienMovementX
            } else {
                alien.position.x -= kAlienMovementX
            }
        }
    }
    
    /// Find the closest alien that can hit the player
    func getNearestAlien() -> Alien? {
        let playerPosition = ship.position
        var nearestAlien: Alien!
        enumerateChildNodesWithName(kAlienName) {alien, stop in
            if nearestAlien != nil {
                // check if the alien is closer vertically
                if alien.position.y < nearestAlien!.position.y && alien.position.x == nearestAlien.position.x {
                    nearestAlien = alien as! Alien
                }
                // check if the alien is closer horizontally
                if abs(alien.position.x - playerPosition.x) <  abs(nearestAlien.position.x - playerPosition.x) {
                    nearestAlien = alien as! Alien
                }
            } else {
                // determine if the alien can hit the player
                if abs(alien.position.x - playerPosition.x) <= kShipSize.width {
                    nearestAlien = alien as! Alien
                }
            }
        }
        return nearestAlien
    }
    
    // MARK: - Contact Delegate
    
    func didBeginContact(contact: SKPhysicsContact) {
        // check if there are less than two nodes in the collision
        if contact.bodyA.node == nil || contact.bodyB.node == nil {
            return
        }
        let node1 = contact.bodyA.node as! SKSpriteNode
        let node2 = contact.bodyB.node as! SKSpriteNode
        
        print(contact.bodyA.categoryBitMask)
        print(contact.bodyB.categoryBitMask)
        
        if contact.bodyA.categoryBitMask == kAlienCategory && contact.bodyB.categoryBitMask == kBulletCategory {
            let alien = node1 as! Alien
            alien.health -= 100
            node2.removeFromParent()
        } else if contact.bodyA.categoryBitMask == kBulletCategory && contact.bodyB.categoryBitMask == kAlienCategory {
            let alien = node2 as! Alien
            alien.health -= 100
            node1.removeFromParent()
        }
    }
    
}
