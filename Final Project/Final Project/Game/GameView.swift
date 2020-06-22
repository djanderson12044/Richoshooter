//
//  GameView.swift
//  Final Project
//
//  Created by Dave & Muchlas BFF on 5/3/20.
//  Copyright © 2020 Dave & Muchlas BFF. All rights reserved.
//

/* Don't think I need this but I'm keeping it for right now*/

import SwiftUI
import SpriteKit

struct GameView: UIViewRepresentable {
    func makeUIView(context: UIViewRepresentableContext<GameView>) -> SKView {
        let view = SKView()
        //let controller = GameViewController()
        
        //controller.view = view
        
        return view
    }
    
    func updateUIView(_ uiView: SKView, context: UIViewRepresentableContext<GameView>) {
        
    }
}
