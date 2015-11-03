//
//  Bunker.swift
//  SpaceInvaders
//
//  Created by Owen LaRosa on 11/1/15.
//  Copyright © 2015 Owen LaRosa. All rights reserved.
//

import SpriteKit

class BunkerNode: SKSpriteNode {
    
    init() {
        super.init(texture: nil, color: kBunkerColor, size: kBunkerSize)
        
        name = kBunkerName
        addPhysics()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addPhysics() {
        // configure the bunker's physics body
        physicsBody = SKPhysicsBody(rectangleOfSize: frame.size)
        physicsBody?.dynamic = true
        physicsBody?.affectedByGravity = false
        physicsBody?.allowsRotation = false
        
        physicsBody?.categoryBitMask = kBunkerCategory
        physicsBody?.contactTestBitMask = 0x0
        physicsBody?.collisionBitMask = 0x0
    }
    
}

class DefenseBunker: SKSpriteNode {
    
    let nodesWide = 5
    let nodesHigh = 5
    let baseX = kBunkerSize.width/2
    let baseY = kBunkerSize.height/2
    
    init() {
        super.init(texture: nil, color: SKColor.clearColor(), size: CGSize(width: Int(kBunkerSize.width) * nodesWide, height: Int(kBunkerSize.height) * nodesHigh))
        // will hold 5x5 grid of BunkerNode objects
        
        setupBunker()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// Add a bunker node at the specified point, x and y begin at zero
    func addNode(x x: Int, y: Int) {
        let xCoordinate = x * Int(kBunkerSize.width) - Int(baseX)
        let yCoordinate = y * Int(kBunkerSize.height) - Int(baseY)
        let bunkerNode = BunkerNode()
        bunkerNode.position = CGPoint(x: xCoordinate, y: yCoordinate)
        addChild(bunkerNode)
    }
    
    /// Add child nodes in a typical bunker formation
    func setupBunker() {
        // top row should have 3 centered nodes
        for i in 2...4 {
            addNode(x: i, y: 5)
        }
        for i in 1...5 {
            switch i {
            case 1:
                // bottom row should contain 2 nodes on the edge
                addNode(x: 1, y: i)
                addNode(x: 5, y: i)
            case 2:
                // second bottom should be filled with nodes except in the middle
                for j in [1, 2, 4, 5] {
                    addNode(x: j, y: i)
                }
            case 3, 4:
                // middle rows should be filled with nodes
                for j in 1...5 {
                    addNode(x: j, y: i)
                }
            case 5:
                // top row should have 3 nodes in the middle
                for j in 2...4 {
                    addNode(x: j, y: i)
                }
            default:
                break
            }
        }
    }
    
}
