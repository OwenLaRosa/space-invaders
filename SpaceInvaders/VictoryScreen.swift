//
//  VictoryScreen.swift
//  SpaceInvaders
//
//  Created by Owen LaRosa on 1/7/16.
//  Copyright © 2016 Owen LaRosa. All rights reserved.
//

import SpriteKit

class VictoryScreen: SKSpriteNode {
    
    let buttonPadding: CGFloat = 8
    
    init() {
        super.init(texture: nil, color: SKColor.blackColor(), size: CGSize(width: kUniversalScreenWidth, height: kUniversalScreenHeight))
        
        alpha = 0.8
        userInteractionEnabled = true
        
        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        let victoryLabel = SKLabelNode()
        victoryLabel.text = "Well done, Earthling."
        victoryLabel.fontName = "Courier-Bold"
        victoryLabel.fontColor = SKColor.greenColor()
        victoryLabel.verticalAlignmentMode = .Center
        victoryLabel.position = CGPoint(x: 0, y: size.height/2 - victoryLabel.frame.size.height - buttonPadding)
        addChild(victoryLabel)
        
        let messageLabel = SKLabelNode()
        messageLabel.text = "You win this time!"
        messageLabel.fontName = "Courier"
        messageLabel.verticalAlignmentMode = .Center
        messageLabel.position = CGPoint(x: 0, y: victoryLabel.position.y - victoryLabel.frame.size.height)
        addChild(messageLabel)
        
        let mainMenuButton = ButtonNode()
        mainMenuButton.text = "Main Menu"
        
        mainMenuButton.verticalAlignmentMode = .Center
        mainMenuButton.position = CGPoint(x: 0, y: 0)
        mainMenuButton.callback = {
            // go back to main menu
            self.scene!.view!.presentScene(MainMenuScene(), transition: SKTransition.doorwayWithDuration(1.0))
        }
        addChild(mainMenuButton)
    }
    
}
