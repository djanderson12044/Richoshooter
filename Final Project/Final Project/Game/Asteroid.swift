//
//  Asteroid.swift
//  Asteroid
//
//  Created by Hayden on 5/8/20.
//  Copyright © 2020 Hayden. All rights reserved.
//

import SpriteKit

class Asteroid: SKSpriteNode {
    var health: Int
    
    init(health: Int, startPosition: CGPoint, yOffset: CGFloat, startSize: CGSize, maxSpeed: CGFloat) {
        //Initialize
        self.health = health
        
        let texture = SKTexture(imageNamed: "asteroid")
        super.init(texture: texture, color: .white, size: startSize)
        
        //Physics
        physicsBody = SKPhysicsBody(circleOfRadius: max(size.width/3, size.height/3))
        physicsBody?.isDynamic = true
        physicsBody?.restitution = 1
        physicsBody?.allowsRotation = false
        physicsBody?.categoryBitMask = PhysicsCategory.asteroid
        physicsBody?.collisionBitMask = PhysicsCategory.player | PhysicsCategory.border | PhysicsCategory.projectile
        physicsBody?.contactTestBitMask = PhysicsCategory.border | PhysicsCategory.player
        
        physicsBody?.velocity = CGVector(dx: 0, dy: maxSpeed)
        
        name = "asteroid"
        position = CGPoint(x: startPosition.x, y: startPosition.y + yOffset)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Asteroid Init Error")
    }
}
