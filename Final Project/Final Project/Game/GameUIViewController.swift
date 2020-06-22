//
//  Game.swift
//  Final Project
//
//  Created by Dave & Muchlas BFF on 5/2/20.
//  Copyright © 2020 Dave & Muchlas BFF. All rights reserved.
//

import SwiftUI
import SpriteKit

struct GameUIViewController: UIViewControllerRepresentable {
    func makeUIViewController(context: UIViewControllerRepresentableContext<GameUIViewController>) -> GameViewController {
        
        let view = GameViewController()
        return view
    }
    
    func updateUIViewController(_ uiViewController: GameViewController, context: UIViewControllerRepresentableContext<GameUIViewController>) {
        
    }
}
