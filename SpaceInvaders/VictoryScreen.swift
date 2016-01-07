//
//  VictoryScreen.swift
//  SpaceInvaders
//
//  Created by Owen LaRosa on 1/7/16.
//  Copyright © 2016 Owen LaRosa. All rights reserved.
//

import SpriteKit

class VictoryScreen: SKSpriteNode {
    
    init() {
        super.init(texture: nil, color: SKColor.blackColor(), size: CGSize(width: kUniversalScreenWidth, height: kUniversalScreenHeight))
        
        alpha = 0.8
        userInteractionEnabled = true
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        
    }
    
}
