//
//  PauseMenu.swift
//  SpaceInvaders
//
//  Created by Owen LaRosa on 11/20/15.
//  Copyright © 2015 Owen LaRosa. All rights reserved.
//

import SpriteKit

class PauseMenu: SKSpriteNode {
    
    init() {
        super.init(texture: nil, color: SKColor.blackColor(), size: CGSize(width: kUniversalScreenWidth, height: kUniversalScreenHeight))
        alpha = 0.8 // user should see paused game
        
        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        
    }
    
}
