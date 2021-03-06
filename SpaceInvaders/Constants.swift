//
//  Constants.swift
//  SpaceInvaders
//
//  Created by Owen LaRosa on 10/26/15.
//  Copyright © 2015 Owen LaRosa. All rights reserved.
//

import Foundation
import SpriteKit

// MARK: - Application

// Use iPhone 6 local resolution to scale up or down
let kUniversalScreenWidth: CGFloat = 667
let kUniversalScreenHeight: CGFloat = 375

// MARK: - Game

let kEarth: CGFloat = 32.0
let kEarthColor = SKColor.greenColor()
let kEarthHeight: CGFloat = 2.0

let kMoveLeftButtonName = "moveLeft"
let kMoveRightButtonName = "moveRight"

// MARK: - Player

let kShipName = "ship"
let kShipSize = CGSize(width: 32, height: 18)
let kShipColor = SKColor.greenColor()
let kPlayerStartingLives = 3

// MARK: - Aliens

let kAlienName = "alien"
let kBossAlienName = "bossAlien"
let kAlienSize = CGSize(width: 24, height: 14)
let kBossAlienSize = CGSize(width: kAlienSize.width * 1.5, height: kAlienSize.height * 1.5)
let kAlienColor = SKColor.whiteColor()

let kAlienRows = 5
let kAlienColumns = 11

let kAlienVerticalSpacing = 10
let kAlienHorizontalSpacing = 10

let kAlienMovementX = kAlienSize.width/2
let kAlienMovementY = (kAlienSize.height + CGFloat(kAlienVerticalSpacing))/2

enum MoveDirection {
    case Left, Right
}

// MARK: - Bullets

let kPlayerBulletName = "playerBullet"
let kAlienBulletName = "alienBulletName"

let kBulletSize = CGSize(width: 2, height: 16)

let kPlayerBulletColor = SKColor.greenColor()
let kAlienBulletColor = SKColor.whiteColor()

let kAlienFastBulletSpeed = 7.0
let kAlienSlowBulletSpeed = 9.0

let kPlayerBulletDamage = 100
let kAlienBulletDamage = 100

// MARK: - Bunkers

let kBunkerName = "bunker"
let kBunkerSize = CGSize(width: 7, height: 7)
let kBunkerColor = SKColor.greenColor()
let kBunkerLocationY = CGFloat(Float(kEarth) * 1.5)

// MARK: - Category Bit Masks

let kArenaCategory: UInt32 = 0x1 << 0
let kShipCategory: UInt32 = 0x1 << 1
let kAlienCategory: UInt32 = 0x1 << 2
let kBulletCategory: UInt32 = 0x1 << 3
let kBunkerCategory: UInt32 = 0x1 << 4
let kEarthCategory: UInt32 = 0x1 << 5
