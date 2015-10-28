//
//  GameScene.swift
//  SpaceInvaders
//
//  Created by Owen LaRosa on 10/26/15.
//  Copyright (c) 2015 Owen LaRosa. All rights reserved.
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
    }
    
}

class Alien: SKSpriteNode {
    
    init() {
        super.init(texture: nil, color: kAlienColor, size: kAlienSize)
        
        name = kAlienName
        addPhysics()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addPhysics() {
        print("addPhysics")
        // configure the alien's physics body
        physicsBody = SKPhysicsBody(rectangleOfSize: frame.size)
        physicsBody?.dynamic = true
        physicsBody?.affectedByGravity = false
    }
    
}

class GameScene: SKScene {
    
    // MARK: - GameProperties
    var aliensLastMoved: CFTimeInterval = 50.0
    
    var ship: Player!
    
    // MARK: - Alien properties
    var alienMoveSpeed = 1.0
    var alienMoveDirection: MoveDirection = .Right
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        configureScreen()
        
        // Create game entities
        addPlayerShip()
        addAliens()
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /* Called when a touch begins */
        
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        
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
            if self.alienMoveDirection == .Right && alien.position.x + kAlienMovementX > self.size.width {
                shouldChangeDirection = true
                return
            } else if self.alienMoveDirection == .Left && alien.position.x - kAlienMovementX < 0 {
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
    
}
