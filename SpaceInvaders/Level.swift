//
//  Level.swift
//  SpaceInvaders
//
//  Created by Owen LaRosa on 11/22/15.
//  Copyright © 2015 Owen LaRosa. All rights reserved.
//

import SpriteKit

struct Level {
    
    let number: Int
    let alienStartingRow: CGFloat
    let boss: BossType?
    
}

// MARK: - Bosses

enum BossType: Int {
    case First
    case Second
    case Third
    case Fourth
    case Fifth
}

typealias BossInfo = (health: Int, points: Int, shootingInterval: Double, animated: Bool)
let bossInfo: [BossInfo] = [
    (health: 300, points: 250, shootingInterval: 3.0, animated: false),
    (health: 400, points: 500, shootingInterval: 2.5, animated: false),
    (health: 500, points: 750, shootingInterval: 2.5, animated: false),
    (health: 600, points: 1000, shootingInterval: 2.0, animated: true),
    (health: 700, points: 2500, shootingInterval: 1.5, animated: true)
]

// MARK: - Level Data

let levels = [
    Level(number: 1, alienStartingRow: 11, boss: nil),
    Level(number: 2, alienStartingRow: 11, boss: BossType.First),
    Level(number: 3, alienStartingRow: 10, boss: nil),
    Level(number: 4, alienStartingRow: 10, boss: BossType.Second),
    Level(number: 5, alienStartingRow: 9, boss: nil),
    Level(number: 6, alienStartingRow: 9, boss: BossType.Third),
    Level(number: 7, alienStartingRow: 8, boss: nil),
    Level(number: 8, alienStartingRow: 8, boss: BossType.Fourth),
    Level(number: 9, alienStartingRow: 7, boss: nil),
    Level(number: 10, alienStartingRow: 7, boss: BossType.Fifth)
]
