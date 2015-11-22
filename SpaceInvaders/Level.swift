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
    
}

// MARK: - Level Data

let levels = [
    Level(number: 1, alienStartingRow: 11),
    Level(number: 2, alienStartingRow: 10),
    Level(number: 3, alienStartingRow: 9),
    Level(number: 4, alienStartingRow: 8)
]
