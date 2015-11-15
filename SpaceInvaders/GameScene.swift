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
    var gameBegan = NSDate()
    var gameData: GameData!
    var scoreBoard: ScoreBoard!
    var aliensRemaining = kAlienRows * kAlienColumns
    
    // MARK: - Player Properties
    var ship: Player!
    var playerShootSpeed = 1.0
    
    // MARK: - Alien properties
    var alienMoveSpeed = 1.0
    var alienMoveDirection: MoveDirection = .Right
    var alienShootSpeed = 1.6
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        
        // allow score keeping
        gameData = GameData(level: 1)
        gameData.lives = kPlayerStartingLives
        configureScreen()
        setupUI()
        
        // add physics body to the game arena
        physicsWorld.contactDelegate = self
        
        // Create game entities
        addBunkers()
        addPlayerShip()
        addAliens()
        addEarthIndicator()
        
        // start the game timer
        gameBegan = NSDate()
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /* Called when a touch begins */
        
        // don't let the player shoot immediately
        if abs(gameBegan.timeIntervalSinceNow) < 1.0 {
            return
        }
        
        // shoot if none of the player's bullets are onscreen
        if childNodeWithName(kPlayerBulletName) == nil {
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
            let targetedOrRandom = arc4random()
            // determine if the alien should be random or close to the player
            if targetedOrRandom % 3 == 1 {
                if let nearestAlien = getNearestAlien() {
                    shootForAlien(nearestAlien)
                } else if let randomAlien = getRandomAlien() {
                    // if no alien is nearby, shoot with a random one
                    shootForAlien(randomAlien)
                }
            } else {
                if let randomAlien = getRandomAlien() {
                    shootForAlien(randomAlien)
                }
            }
            aliensLastShot = currentTime
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
    }
    
    /// Add buttons and labels to the scene
    func setupUI() {
        scoreBoard = ScoreBoard(size: CGSize(width: size.width, height: 30))
        scoreBoard.gameData = gameData
        scoreBoard.configureLabel()
        scoreBoard.position = CGPoint(x: size.width/2, y: size.height - scoreBoard.frame.size.height/2)
        addChild(scoreBoard)
        
        let leftButton = LongPressButtonNode()
        leftButton.name = kMoveLeftButtonName
        leftButton.text = "<"
        leftButton.fontSize = 85
        leftButton.position = CGPoint(x: leftButton.frame.size.width/2, y: 0)
        leftButton.callback = {
            let moveLeft = SKAction.moveTo(CGPoint(x: self.ship.position.x - 5, y: self.ship.position.y), duration: 0.05)
            self.ship.runAction(moveLeft)
        }
        addChild(leftButton)
        
        let rightButton = LongPressButtonNode()
        rightButton.name = kMoveRightButtonName
        rightButton.text = ">"
        rightButton.fontSize = 85
        rightButton.position = CGPoint(x: size.width - rightButton.frame.size.width/2, y: 0)
        rightButton.callback = {
            let moveRight = SKAction.moveTo(CGPoint(x: self.ship.position.x + 5, y: self.ship.position.y), duration: 0.05)
            self.ship.runAction(moveRight)
        }
        addChild(rightButton)
        
        let pauseButton = ButtonNode()
        pauseButton.text = "▌▌"
        pauseButton.fontSize = 20
        pauseButton.position = CGPoint(x: size.width - pauseButton.frame.size.width/2 - 4, y: size.height - pauseButton.frame.size.height/2 - 8)
        pauseButton.callback = {
            self.pauseGame(!self.paused)
        }
        addChild(pauseButton)
    }
    
    /// Arrange defense bunkers on the view
    func addBunkers() {
        // determine locations of the bunkers
        let leftMost = getAliensOrigin().x
        let rightMost = size.width - leftMost
        let distanceBetweenBunkers = (rightMost - leftMost)/3.0
        let bunkerLocations = [
            CGPoint(x: leftMost, y: kBunkerLocationY),
            CGPoint(x: leftMost + distanceBetweenBunkers, y: kBunkerLocationY),
            CGPoint(x: rightMost - distanceBetweenBunkers, y: kBunkerLocationY),
            CGPoint(x: rightMost, y: kBunkerLocationY)
        ]
        for i in bunkerLocations {
            let bunker = DefenseBunker()
            bunker.position = i
            addChild(bunker)
        }
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
        for i in 1...kAlienRows {
            var nextXOrigin = aliensOrigin.x + kAlienSize.width/2.0
            for _ in 1...kAlienColumns {
                let alien = Alien()
                alien.position = CGPoint(x: nextXOrigin, y: nextYOrigin)
                switch i {
                case 1: // top row
                    alien.color = SKColor.redColor()
                    alien.points = 30
                case 2, 3: // middle rows
                    alien.color = SKColor.blueColor()
                    alien.points = 20
                case 4, 5: // bottom row
                    alien.color = SKColor.yellowColor()
                    alien.points = 10
                default:
                    return
                }
                addChild(alien)
                nextXOrigin += kAlienSize.width + CGFloat(kAlienHorizontalSpacing)
            }
            nextYOrigin -= kAlienSize.height + CGFloat(kAlienHorizontalSpacing)
        }
    }
    
    /// Add a line that signals Earth's location
    func addEarthIndicator() {
        let earth = Earth(width: size.width)
        earth.position = CGPoint(x: size.width/2, y: kEarth)
        addChild(earth)
    }
    
    /// Returns starting coordinate for placing aliens
    func getAliensOrigin() -> CGPoint {
        // width and height of entire alien grid, including spacing
        let totalWidth = kAlienColumns * Int(kAlienSize.width) + (kAlienColumns - 1) * kAlienHorizontalSpacing
        let totalHeight = kAlienRows * Int(kAlienSize.height) + (kAlienRows - 1) * kAlienVerticalSpacing
        
        let xOrigin = size.width/2.0 - CGFloat(totalWidth/2)
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
    
    /// Gets a random alien currently in the game
    func getRandomAlien() -> Alien? {
        var aliens = [Alien]()
        enumerateChildNodesWithName(kAlienName) {alien, stop in
            aliens.append(alien as! Alien)
        }
        if aliens.isEmpty {
            return nil
        }
        let randomIndex = arc4random() % UInt32(aliens.count)
        return aliens[Int(randomIndex)]
    }
    
    func shootForAlien(alien: Alien) {
        let bulletSpeed = arc4random_uniform(2)
        if bulletSpeed % 2 == 1 {
            alien.shoot(kAlienFastBulletSpeed)
        } else if bulletSpeed % 2 == 0 {
            alien.shoot(kAlienSlowBulletSpeed)
        }
    }
    
    // MARK: - Contact Delegate
    
    func didBeginContact(contact: SKPhysicsContact) {
        // check if there are less than two nodes in the collision
        if contact.bodyA.node == nil || contact.bodyB.node == nil {
            return
        }
        let node1 = contact.bodyA.node as! SKSpriteNode
        let node2 = contact.bodyB.node as! SKSpriteNode
        
        if contact.bodyA.categoryBitMask == kAlienCategory && contact.bodyB.categoryBitMask == kBulletCategory {
            bulletHitAlien(bullet: node2 as! Bullet, alien: node1 as! Alien)
        } else if contact.bodyA.categoryBitMask == kBulletCategory && contact.bodyB.categoryBitMask == kAlienCategory {
            bulletHitAlien(bullet: node1 as! Bullet, alien: node2 as! Alien)
        } else if contact.bodyA.categoryBitMask == kBulletCategory && contact.bodyB.categoryBitMask == kBunkerCategory {
            bulletHitBunker(bullet: node1 as! Bullet, bunker: node2 as! BunkerNode)
        } else if contact.bodyA.categoryBitMask == kBunkerCategory && contact.bodyB.categoryBitMask == kBulletCategory {
            bulletHitBunker(bullet: node2 as! Bullet, bunker: node1 as! BunkerNode)
        } else if contact.bodyA.categoryBitMask == kShipCategory && contact.bodyB.categoryBitMask == kBulletCategory {
            bulletHitPlayer(bullet: node2 as! Bullet, player: node1 as! Player)
        } else if contact.bodyA.categoryBitMask == kBulletCategory && contact.bodyB.categoryBitMask == kShipCategory {
            bulletHitPlayer(bullet: node1 as! Bullet, player: node2 as! Player)
        } else if contact.bodyA.categoryBitMask == kAlienCategory && contact.bodyB.categoryBitMask == kBunkerCategory {
            node2.removeFromParent()
        } else if contact.bodyA.categoryBitMask == kBunkerCategory && contact.bodyB.categoryBitMask == kAlienCategory {
            node1.removeFromParent()
        } else if contact.bodyA.categoryBitMask == kAlienCategory && contact.bodyB.categoryBitMask == kEarthCategory {
            print("alien reached earth")
        } else if contact.bodyA.categoryBitMask == kEarthCategory && contact.bodyB.categoryBitMask == kAlienCategory {
            print("alien reached earth")
        }
    }
    
    /// Handle contact between a bullet and an alien
    func bulletHitAlien(bullet bullet: Bullet, alien: Alien) {
        alien.health -= bullet.damage
        if alien.health <= 0 {
            alien.removeFromParent()
            aliensRemaining--
            // aliens should get faster
            if aliensRemaining <= 10 {
                // large amount if near end of game
                alienMoveSpeed -= 0.02
            } else {
                // small amount at first
                alienMoveSpeed -= 0.015
            }
            if aliensRemaining == 1 {
                // fastest move speed
                alienMoveSpeed = 0.1
            }
            // aliens should shoot slower
            // this ensures there aren't too may bullets for too few aliens
            alienShootSpeed += 0.001
            // if the alien is dead, update the score
            gameData.score += alien.points
            scoreBoard.configureLabel()
        }
        bullet.removeFromParent()
    }
    
    /// Handle contact between a bullet and the player
    func bulletHitPlayer(bullet bullet: Bullet, player: Player) {
        player.health -= bullet.damage
        gameData.lives--
        scoreBoard.configureLabel()
        if player.health <= 0 {
            // normally, the player would be killed
            // for debugging purposes, this will be added later
        }
    }
    
    /// Handle contact between a bullet and a bunker
    func bulletHitBunker(bullet bullet: Bullet, bunker: BunkerNode) {
        bullet.removeFromParent()
        bunker.removeFromParent()
    }
    
    /// Toggles the paused state of the game and enables/disables relevant UI
    func pauseGame(shouldPause: Bool) {
        paused = shouldPause
        userInteractionEnabled = !shouldPause
        (childNodeWithName(kMoveLeftButtonName) as! ButtonNode).userInteractionEnabled = !shouldPause
        (childNodeWithName(kMoveRightButtonName) as! ButtonNode).userInteractionEnabled = !shouldPause
    }
    
}
