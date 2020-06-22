//
//  Projectile.swift
//  Final Project
//
//  Created by Dave & Muchlas BFF on 5/10/20.
//  Copyright © 2020 Dave & Muchlas BFF. All rights reserved.
//

import SpriteKit

class Projectile: SKSpriteNode {
    init(startPos: CGPoint) {
        let texture = SKTexture(imageNamed: "redbullet")
        super.init(texture: texture, color: .white, size: texture.size())
        
        name = "projectile"
        size = CGSize(width: 20, height: 20)
        position = startPos
        physicsBody = SKPhysicsBody(circleOfRadius: max(size.width, size.height))
        
        physicsBody?.affectedByGravity = false
        physicsBody?.isDynamic = true
        physicsBody?.usesPreciseCollisionDetection = true // Cause its moving pretty fast.
        physicsBody?.allowsRotation = false
        
        physicsBody?.restitution = 1.0
        physicsBody?.linearDamping = 0
        physicsBody?.friction = 0
        //bullet.physicsBody?.mass = CGFloat(3.0)
        
        physicsBody?.categoryBitMask = PhysicsCategory.projectile
        physicsBody?.collisionBitMask = PhysicsCategory.asteroid | PhysicsCategory.border
        physicsBody?.contactTestBitMask = PhysicsCategory.asteroid | PhysicsCategory.border
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Projectile Init Error")
    }
}
