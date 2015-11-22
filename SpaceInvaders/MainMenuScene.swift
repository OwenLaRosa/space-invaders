//
//  MainMenuScene.swift
//  SpaceInvaders
//
//  Created by Owen LaRosa on 11/15/15.
//  Copyright © 2015 Owen LaRosa. All rights reserved.
//

import SpriteKit

class MainMenuScene: SKScene {
    
    let buttonPadding: CGFloat = 8
    
    override func didMoveToView(view: SKView) {
        //super.didMoveToView(view)
        
        configureUI()
    }
    
    func configureUI() {
        size.width = kUniversalScreenWidth
        size.height = kUniversalScreenHeight
        
        // set the scene's background
        backgroundColor = SKColor.blueColor()
        
        // create black 3D border for main view
        let border = SKSpriteNode(texture: nil, color: SKColor.blackColor(), size: CGSize(width: size.width - 100, height: size.height - 100))
        border.position = CGPoint(x: size.width/2 + 20, y: size.height/2 - 20)
        addChild(border)
        
        // create main menu with light gray background
        let mainMenu = SKSpriteNode(texture: nil, color: SKColor.lightGrayColor(), size: border.size)
        mainMenu.position = CGPoint(x: border.position.x - 20, y: border.position.y + 20)
        addChild(mainMenu)
        
        addButtonsAndLabels(mainMenu)
    }
    
    func addButtonsAndLabels(container: SKSpriteNode) {
        let titleLabel = SKLabelNode(text: "SPACE INVADERS")
        titleLabel.fontName = "Courier-Bold"
        titleLabel.fontColor = SKColor.blueColor()
        titleLabel.fontSize = 50
        titleLabel.verticalAlignmentMode = .Center
        titleLabel.position = CGPoint(x: 0, y: container.size.height/2 - titleLabel.frame.size.height)
        container.addChild(titleLabel)
        
        let playButton = ButtonNode()
        playButton.text = "Play"
        playButton.fontSize = 40
        playButton.fontColor = SKColor.whiteColor()
        playButton.verticalAlignmentMode = .Center
        playButton.position = CGPoint(x: 0, y: 0)
        playButton.callback = {
            let gameScene = GameScene()
            gameScene.level = Level(number: 1, alienStartingRow: 11)
            self.view?.presentScene(gameScene, transition: SKTransition.doorwayWithDuration(1.0))
        }
        addButton(toContainer: container, node: playButton)
        
        let optionsButton = ButtonNode()
        optionsButton.text = "Options"
        optionsButton.fontSize = 40
        optionsButton.fontColor = SKColor.whiteColor()
        optionsButton.verticalAlignmentMode = .Center
        optionsButton.position = CGPoint(x: 0, y: -optionsButton.frame.size.height - buttonPadding)
        addButton(toContainer: container, node: optionsButton)
    }
    
    func addButton(toContainer container: SKNode, node: SKNode) {
        let buttonBackground = ButtonBackground(button: node as! ButtonNode)
        buttonBackground.size.width = 200
        buttonBackground.position = node.position
        
        container.addChild(buttonBackground)
        container.addChild(node)
    }
    
}
