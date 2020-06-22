//
//  File.swift
//  Final Project
//
//  Created by Dave & Muchlas BFF on 4/27/20.
//  Copyright © 2020 Dave & Muchlas BFF. All rights reserved.
//

import SwiftUI
import SpriteKit

struct SpaceShip: UIViewRepresentable {
    func makeUIView(context: UIViewRepresentableContext<SpaceShip>) -> SKView {
        let view = SKView()
        return view
    }
    
    func updateUIView(_ uiView: SKView, context: UIViewRepresentableContext<SpaceShip>) {
        
    }
}


// Everything displayed with SpriteKit is done using a scene object.
class Ship: SKScene {
    override func  didMove(to view: SKView) {
        super.didMove(to: view)
        
        if let emitter: SKEmitterNode = SKEmitterNode(fileNamed: "love") {
            emitter.alpha = 0
            
            addChild(emitter) // Adds a node to the end of the receiver's list of child nodes.
            
            emitter.run(SKAction.fadeIn(withDuration: 0.5)) {
                emitter.run(SKAction.fadeOut(withDuration: 5.0)) {
                    
                    emitter.removeFromParent()
                    
                }
            }
        }
    }
}
