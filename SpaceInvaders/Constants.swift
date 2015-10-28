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

// MARK: - Player

let kShipName = "ship"
let kShipSize = CGSize(width: 48, height: 24)
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
