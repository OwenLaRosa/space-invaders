//
//  ButtonNode.swift
//  SpaceInvaders
//
//  Created by Owen LaRosa on 11/1/15.
//  Copyright © 2015 Owen LaRosa. All rights reserved.
//

import SpriteKit

class ButtonNode: SKLabelNode {
    
    var callback: () -> Void
    
    override init() {
        callback = {}
        super.init()
        fontName = "Courier"
        fontSize = 50
        userInteractionEnabled = true
        color = SKColor.grayColor()
        fontColor = SKColor.cyanColor()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        callback()
    }
    
}
