//
//  PauseMenu.swift
//  SpaceInvaders
//
//  Created by Owen LaRosa on 11/20/15.
//  Copyright © 2015 Owen LaRosa. All rights reserved.
//

import SpriteKit

class PauseMenu: SKSpriteNode {
    
    let buttonPadding: CGFloat = 8
    
    init() {
        super.init(texture: nil, color: SKColor.blackColor(), size: CGSize(width: kUniversalScreenWidth, height: kUniversalScreenHeight))
        alpha = 0.8 // user should see paused game
        userInteractionEnabled = true
        
        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        let pauseLabel = SKLabelNode()
        pauseLabel.text = "PAUSED"
        pauseLabel.fontName = "Courier-Bold"
        pauseLabel.color = SKColor.whiteColor()
        pauseLabel.verticalAlignmentMode = .Center
        pauseLabel.position = CGPoint(x: 0, y: size.height/2 - pauseLabel.frame.size.height - buttonPadding)
        addChild(pauseLabel)
        
        let resumeButton = ButtonNode()
        resumeButton.text = "Resume"
        resumeButton.verticalAlignmentMode = .Center
        resumeButton.position = CGPoint(x: 0, y: resumeButton.frame.size.height + buttonPadding/2)
        resumeButton.callback = {
            // get current scene
            let scene = self.scene as! GameScene
            // reveal the game scene
            self.removeFromParent()
            // unpause the game
            scene.pauseGame(false)
        }
        addChild(resumeButton)
        
        let quitButton = ButtonNode()
        quitButton.text = "Quit"
        quitButton.verticalAlignmentMode = .Center
        quitButton.position = CGPoint(x: 0, y: -resumeButton.frame.size.height - buttonPadding/2)
        quitButton.callback = {
            // go back to main menu
            self.scene!.view!.presentScene(MainMenuScene(), transition: SKTransition.doorwayWithDuration(1.0))
        }
        addChild(quitButton)
    }
    
}
