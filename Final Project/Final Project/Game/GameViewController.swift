//
//  GameViewController.swift
//  Final Project
//
//  Created by Dave & Muchlas BFF on 4/30/20.
//  Copyright © 2020 Dave & Muchlas BFF. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit
import SwiftUI

class GameViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initial view is a UIView that for some reason can't be casted to an SKView.
        // So, gotta do this in order to cast it.
        let fr = self.view.frame
        self.view = SKView(frame: fr)
        
        let skview = self.view as! SKView
        let scene = GameScene(size: CGSize(width: view.frame.width, height: view.frame.height))
        
        /* Apparently dimensions of the scene and the appare different so have to use this.
         
         Might need to try looking into .sks to see what that is and what we can do with that.*/
        scene.scaleMode = .resizeFill
        
        skview.presentScene(scene)
        
        skview.ignoresSiblingOrder = true
        
        skview.showsFPS = true
        skview.showsNodeCount = true
    }

    override var shouldAutorotate: Bool {
        return false
    }
}
