//
//  GameData.swift
//  SpaceInvaders
//
//  Created by Owen LaRosa on 11/13/15.
//  Copyright © 2015 Owen LaRosa. All rights reserved.
//

import Foundation

class GameData {
    
    var level: Int
    var score: Int
    var lives: Int
    
    init(level: Int) {
        self.level = level
        score = 0
        lives = 1
    }
    
}

let globalGameData = GameData(level: levels[0].number)
