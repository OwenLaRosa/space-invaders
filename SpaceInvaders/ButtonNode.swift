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

class LongPressButtonNode: ButtonNode {
    
    var active = false
    var callbackTimer = NSTimer()
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        active = true
        callbackTimer = NSTimer(fireDate: NSDate(), interval: 0.01, target: self, selector: "performCallback", userInfo: nil, repeats: true)
        NSRunLoop.currentRunLoop().addTimer(callbackTimer, forMode: NSRunLoopCommonModes)
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        active = false
        callbackTimer.invalidate()
    }
    
    func performCallback() {
        if active {
            callback()
        }
    }
    
}

class ButtonBackground: SKSpriteNode {
    
    var callback: () -> Void
    
    init(button: ButtonNode) {
        callback = button.callback
        super.init(texture: nil, color: SKColor.blueColor(), size: button.frame.size)
        userInteractionEnabled = true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        callback()
    }
    
}
