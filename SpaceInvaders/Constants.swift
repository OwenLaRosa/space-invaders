//
//  Constants.swift
//  SpaceInvaders
//
//  Created by Owen LaRosa on 10/26/15.
//  Copyright © 2015 Owen LaRosa. All rights reserved.
//

import Foundation
import SpriteKit

// MARK: - Game

let kEarth = 32

let kMoveLeftButtonName = "moveLeft"
let kMoveRightButtonName = "moveRight"

// MARK: - Player

let kShipName = "ship"
let kShipSize = CGSize(width: 36, height: 18)
let kShipColor = SKColor.greenColor()

// MARK: - Aliens

let kAlienName = "alien"
let kAlienSize = CGSize(width: 24, height: 18)
let kAlienColor = SKColor.whiteColor()

let kAlienRows = 5
let kAlienColumns = 11

let kAlienVerticalSpacing = 6
let kAlienHorizontalSpacing = 10

let kAlienMovementX = kAlienSize.width/2
let kAlienMovementY = kAlienSize.height/2

enum MoveDirection {
    case Left, Right
}

// MARK: - Bullets

let kPlayerBulletName = "playerBullet"
let kAlienBulletName = "alienBulletName"

let kBulletSize = CGSize(width: 2, height: 16)

let kPlayerBulletColor = SKColor.greenColor()
let kAlienBulletColor = SKColor.whiteColor()

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
