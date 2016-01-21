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
    var level: Level!
    var isFirstUpdate = true
    var lastPausedAt = NSDate()
    var aliensLastMoved: CFTimeInterval = 2.0
    var playerLastShot = NSDate()
    var aliensLastShot: CFTimeInterval = 1.5
    var bossLastShot: CFTimeInterval = 1.0 // less time than normal to avoid "cheap shots"
    var gameBegan = NSDate()
    //var gameData: GameData!
    var scoreBoard: ScoreBoard!
    var aliensRemaining = kAlienRows * kAlienColumns
    
    // MARK: - Player Properties
    var ship: Player!
    var playerShootSpeed = 1.0
    
    // MARK: - Alien properties
    var boss: BossAlien?
    var alienMoveSpeed = 1.0
    var alienMoveDirection: MoveDirection = .Right
    var alienShootSpeed = 1.6
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        
        // allow score keeping
        configureScreen()
        setupUI()
        
        // add physics body to the game arena
        physicsWorld.contactDelegate = self
        
        // Create game entities
        addBunkers()
        addPlayerShip()
        addAliens()
        if let boss = level.boss {
            addBoss(boss)
        }
        addEarthIndicator()
        
        // start the game timer
        gameBegan = NSDate()
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /* Called when a touch begins */
        
        // don't let the player shoot immediately
        if abs(gameBegan.timeIntervalSinceNow) < 2.0 {
            return
        }
        
        // shoot if none of the player's bullets are onscreen
        if childNodeWithName(kPlayerBulletName) == nil {
            ship.shoot()
        }
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        if paused {
            return
        }
        
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
        
        if boss != nil {
            if (currentTime - boss!.shootingInterval) >= bossLastShot {
                boss!.shoot(kAlienSlowBulletSpeed)
                bossLastShot = currentTime
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
        // use the screen's aspect ratio to determine the appropriate width
        let screenBounds = UIScreen.mainScreen().bounds
        let aspectRatio = screenBounds.width / screenBounds.height
        size.width = kUniversalScreenHeight * aspectRatio
        // relative height will always be the same
        size.height = kUniversalScreenHeight
        backgroundColor = SKColor.blackColor()
        
        // set up consistent game arena for all device screens
        minLocationX = getAliensOrigin().x - CGFloat(kAlienMovementX * 8) - 1.0 // number of movements on 5, 5s
        maxLocationX = abs(size.width - getAliensOrigin().x) + CGFloat(kAlienMovementX * 8) + 1.0
    }
    
    /// Add buttons and labels to the scene
    func setupUI() {
        scoreBoard = ScoreBoard(size: CGSize(width: size.width, height: 30))
        scoreBoard.gameData = globalGameData
        scoreBoard.zPosition = 5
        scoreBoard.configureLabel()
        scoreBoard.position = CGPoint(x: size.width/2, y: size.height - scoreBoard.frame.size.height/2)
        addChild(scoreBoard)
        
        let leftButton = LongPressButtonNode()
        leftButton.name = kMoveLeftButtonName
        leftButton.text = "<"
        leftButton.fontSize = CGFloat(currentControlSize.rawValue)
        leftButton.zPosition = 5
        leftButton.callback = {
            if self.ship.position.x - 5 > 0 {
                let moveLeft = SKAction.moveTo(CGPoint(x: self.ship.position.x - 5, y: self.ship.position.y), duration: 0.05)
                self.ship.runAction(moveLeft)
            }
        }
        
        let rightButton = LongPressButtonNode()
        rightButton.name = kMoveRightButtonName
        rightButton.text = ">"
        rightButton.fontSize = CGFloat(currentControlSize.rawValue)
        rightButton.zPosition = 5
        rightButton.callback = {
            if self.ship.position.x + 5 < self.size.width {
                let moveRight = SKAction.moveTo(CGPoint(x: self.ship.position.x + 5, y: self.ship.position.y), duration: 0.05)
                self.ship.runAction(moveRight)
            }
            
        }
        
        // position the buttons based on the control scheme
        switch currentControlScheme {
        case .BothSides:
            leftButton.position = CGPoint(x: leftButton.frame.size.width/2, y: 0)
            rightButton.position = CGPoint(x: size.width - rightButton.frame.size.width/2, y: 0)
        case .LeftSide:
            leftButton.position = CGPoint(x: leftButton.frame.size.width/2, y: 0)
            rightButton.position = CGPoint(x: leftButton.frame.size.width + rightButton.frame.size.width/2, y: 0)
        case .RightSide:
            leftButton.position = CGPoint(x: size.width - rightButton.frame.size.width - leftButton.frame.size.width/2, y: 0)
            rightButton.position = CGPoint(x: size.width - rightButton.frame.size.width/2, y: 0)
        }
        
        addChild(leftButton)
        addChild(rightButton)
        
        let pauseButton = ButtonNode()
        pauseButton.text = "▌▌"
        pauseButton.fontSize = 20
        pauseButton.position = CGPoint(x: size.width - pauseButton.frame.size.width/2 - 4, y: size.height - pauseButton.frame.size.height/2 - 8)
        pauseButton.zPosition = 6 // above scoreboard
        pauseButton.callback = {
            self.pauseGame(!self.paused)
            let pauseMenu = PauseMenu()
            pauseMenu.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
            pauseMenu.zPosition = 10
            self.addChild(pauseMenu)
        }
        addChild(pauseButton)
    }
    
    /// Arrange defense bunkers on the view
    func addBunkers() {
        // determine locations of the bunkers
        let leftMost = getAliensOrigin().x
        let rightMost = size.width - leftMost
        let distanceBetweenBunkers = (rightMost - leftMost)/3.0
        // four total bunkers, equally spaced
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
    
    /// Add a boss alien of the specified type to the game
    func addBoss(type: BossType) {
        boss = BossAlien(type: type)
        let aliensOrigin = getAliensOrigin()
        let startingHeight = aliensOrigin.y + kAlienSize.height + CGFloat(kAlienVerticalSpacing) + boss!.size.height/2
        boss!.position = CGPoint(x: size.width/2, y: startingHeight)
        addChild(boss!)
    }
    
    /// Add a line that signals Earth's location
    func addEarthIndicator() {
        let earth = Earth(width: size.width)
        earth.position = CGPoint(x: size.width/2, y: kEarth - kEarthHeight/2.0)
        addChild(earth)
    }
    
    /// Returns starting coordinate for placing aliens
    func getAliensOrigin() -> CGPoint {
        // width and height of entire alien grid, including spacing
        let totalWidth = kAlienColumns * Int(kAlienSize.width) + (kAlienColumns - 1) * kAlienHorizontalSpacing
        
        let xOrigin = size.width/2.0 - CGFloat(totalWidth/2)
        let yOrigin = (kAlienSize.height + CGFloat(kAlienVerticalSpacing)) * level.alienStartingRow + kEarth
        
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
        moveBoss(changeDirection: shouldChangeDirection)
    }
    
    /// Move the boss alien to the next appropriate location
    func moveBoss(changeDirection changeDirection: Bool) {
        // return if the level does not contain a boss
        if boss == nil {
            return
        }
        if aliensRemaining == 0 {
            moveBossContinuous()
            return
        }
        // check if the boss should move vertically
        if changeDirection {
            boss!.position.y -= kAlienMovementY
            return
        }
        // some mild repetition, just like the previous method
        if self.alienMoveDirection == .Right  {
            boss!.position.x += kAlienMovementX
        } else {
            boss!.position.x -= kAlienMovementX
        }
    }
    
    /// Move the boss in a continuous path. This is used at the end of the game when there are no more aliens to govern movement.
    func moveBossContinuous() {
        // identifier for movement actions
        let actionKey = "bossMove"
        // check if a move action is already executing
        if boss!.actionForKey(actionKey) != nil {
            // if so, then do nothing
            return
        }
        let moveDuration: CGFloat = 3.0 // 3 seconds
        // distance between the minimum and maximum locations for aliens
        let totalDistance = maxLocationX - minLocationX
        if alienMoveDirection == .Right {
            // calculate duration based on distance to the destination
            let actualDuration = (maxLocationX! - boss!.position.x) / totalDistance * moveDuration
            let moveAction = SKAction.moveToX(maxLocationX, duration: abs(NSTimeInterval(actualDuration)))
            // move down when the action is completed
            let descend = SKAction.moveToY(boss!.position.y - kAlienMovementY, duration: 0.1)
            let sequence = SKAction.sequence([moveAction, descend])
            boss!.runAction(sequence, withKey: actionKey)
            // change movement direction
            alienMoveDirection = .Left
        } else { // move left
            let actualDuration = (boss!.position.x - minLocationX) / totalDistance * moveDuration
            let moveAction = SKAction.moveToX(minLocationX, duration: abs(NSTimeInterval(actualDuration)))
            let descend = SKAction.moveToY(boss!.position.y - kAlienMovementY, duration: 0.1)
            let sequence = SKAction.sequence([moveAction, descend])
            boss!.runAction(sequence, withKey: actionKey)
            alienMoveDirection = .Right
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
        // get an array of all existing alien nodes
        var aliens = [Alien]()
        enumerateChildNodesWithName(kAlienName) {alien, stop in
            aliens.append(alien as! Alien)
        }
        // don't return an alien if none are available
        if aliens.isEmpty {
            return nil
        }
        // get and return a random alien
        let randomIndex = arc4random() % UInt32(aliens.count)
        return aliens[Int(randomIndex)]
    }
    
    func shootForAlien(alien: Alien) {
        // determine bullet speed from two possible values, fast and slow
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
        // get a reference to each node
        let node1 = contact.bodyA.node as! SKSpriteNode
        let node2 = contact.bodyB.node as! SKSpriteNode
        
        // check for different types of contact
        if contact.bodyA.categoryBitMask == kAlienCategory && contact.bodyB.categoryBitMask == kBulletCategory {
            // the player's bullet hit an alien
            bulletHitAlien(bullet: node2 as! Bullet, alien: node1 as! Alien)
        } else if contact.bodyA.categoryBitMask == kBulletCategory && contact.bodyB.categoryBitMask == kAlienCategory {
            bulletHitAlien(bullet: node1 as! Bullet, alien: node2 as! Alien)
        } else if contact.bodyA.categoryBitMask == kBulletCategory && contact.bodyB.categoryBitMask == kBunkerCategory {
            // any bullet hit a bunker
            bulletHitBunker(bullet: node1 as! Bullet, bunker: node2 as! BunkerNode)
        } else if contact.bodyA.categoryBitMask == kBunkerCategory && contact.bodyB.categoryBitMask == kBulletCategory {
            bulletHitBunker(bullet: node2 as! Bullet, bunker: node1 as! BunkerNode)
        } else if contact.bodyA.categoryBitMask == kShipCategory && contact.bodyB.categoryBitMask == kBulletCategory {
            // an alien's bullet hit the ship
            bulletHitPlayer(bullet: node2 as! Bullet, player: node1 as! Player)
        } else if contact.bodyA.categoryBitMask == kBulletCategory && contact.bodyB.categoryBitMask == kShipCategory {
            bulletHitPlayer(bullet: node1 as! Bullet, player: node2 as! Player)
        } else if contact.bodyA.categoryBitMask == kAlienCategory && contact.bodyB.categoryBitMask == kBunkerCategory {
            // an alien hit a bunker, bunker node will be removed
            node2.removeFromParent()
        } else if contact.bodyA.categoryBitMask == kBunkerCategory && contact.bodyB.categoryBitMask == kAlienCategory {
            node1.removeFromParent()
        } else if contact.bodyA.categoryBitMask == kAlienCategory && contact.bodyB.categoryBitMask == kEarthCategory {
            // any alien has reached earth, the game is lost
            //endGame(victory: false)
        } else if contact.bodyA.categoryBitMask == kEarthCategory && contact.bodyB.categoryBitMask == kAlienCategory {
            //endGame(victory: false)
        }
    }
    
    /// Handle contact between a bullet and an alien
    func bulletHitAlien(bullet bullet: Bullet, alien: Alien) {
        // make sure the same bullet can't kill multiple aliens
        if bullet.parent == nil {
            return
        }
        // remove appropriate health from the alien
        alien.health -= bullet.damage
        if alien.health <= 0 {
            // if the alien would be killed, remove it
            alien.removeFromParent()
            // decrease the alien count if it's a regular alien
            if let _ = alien as? BossAlien {
                // award the player an extra life upon killing a boss
                globalGameData.lives++
            } else {
                aliensRemaining--
            }
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
            globalGameData.score += alien.points
            scoreBoard.configureLabel()
            // check for player victory (all aliens have been killed)
            // right side will be true of no boss exists
            if aliensRemaining == 0 && boss?.health ?? 0 <= 0 {
                // player wins, award an extra life go to next level
                globalGameData.lives++
                goToNextLevel()
            }
        }
        // bullet should disappear after contact
        bullet.removeFromParent()
    }
    
    /// Handle contact between a bullet and the player
    func bulletHitPlayer(bullet bullet: Bullet, player: Player) {
        // decrease the player's health and lives count by the appropriate amount
        player.health -= bullet.damage
        if bullet.damage > 0 {
            globalGameData.lives--
        }
        // update the scoreboard to reflect the changes
        scoreBoard.configureLabel()
        if globalGameData.lives <= 0 {
            // normally, the player would be killed
            // for debugging purposes, this will be added later
            //endGame(victory: false)
        }
    }
    
    /// Handle contact between a bullet and a bunker
    func bulletHitBunker(bullet bullet: Bullet, bunker: BunkerNode) {
        // when any bullets hits a bunker, both the bullet and bunker node will be destroyed
        bullet.removeFromParent()
        bunker.removeFromParent()
    }
    
    /// Toggles the paused state of the game and enables/disables relevant UI
    func pauseGame(shouldPause: Bool) {
        paused = shouldPause
        if paused {
            lastPausedAt = NSDate()
        } else {
            // ensure updates don't occur more often than normal
            let timeSinceLastPause = -lastPausedAt.timeIntervalSinceNow
            aliensLastMoved += timeSinceLastPause
            aliensLastShot += timeSinceLastPause
        }
        userInteractionEnabled = !shouldPause
        (childNodeWithName(kMoveLeftButtonName) as! ButtonNode).userInteractionEnabled = !shouldPause
        (childNodeWithName(kMoveRightButtonName) as! ButtonNode).userInteractionEnabled = !shouldPause
    }
    
    /// Transition to the next level if another is available. Otherwise, show the victory scene.
    func goToNextLevel() {
        // check if another level is available
        if level!.number < levels.count {
            let gameScene = GameScene()
            let nextLevel = levels[level!.number] // next level
            gameScene.level = nextLevel
            // update the level count
            globalGameData.level = nextLevel.number
            view?.presentScene(gameScene, transition: SKTransition.doorwayWithDuration(1.0))
        } else {
            // if not, then the player wins the game
            //endGame(victory: true)
        }
        
    }
    
    /// End the game and show the game over screen.
    func endGame(victory victory: Bool) {
        // suspend all game activity
        pauseGame(true)
        // display the appropriate game over screen
        let gameOverScreen = GameOverScreen(victory: victory)
        gameOverScreen.zPosition = 15
        gameOverScreen.position = CGPoint(x: size.width/2, y: size.height/2)
        addChild(gameOverScreen)
    }
    
}
