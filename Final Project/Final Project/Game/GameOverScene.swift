//
//  GameOverScene.swift
//  Final Project
//
//  Created by Dave & Muchlas BFF on 5/10/20.
//  Copyright © 2020 Dave & Muchlas BFF. All rights reserved.
//

import SpriteKit

class GameOverScene: SKScene{
    var score:Int
    
    init(size: CGSize, score: Int, view: SKView?) {
        self.score = score
        super.init(size: size)
        
        if let background = SKEmitterNode(fileNamed: "StarBackground") {
            background.name = "background"
            background.position = CGPoint(x: frame.midX, y: frame.height)
            background.zPosition = -1;
            background.advanceSimulationTime(30)
            
            addChild(background)
        } else {
            print("Background Didn't load")
        }
        
        let message = "Score: \(score)"
        
        let label = SKLabelNode(fontNamed: "Chalkduster")
        label.text = message
        label.fontSize = 40
        label.fontColor = SKColor.white
        label.position = CGPoint(x: size.width/2, y: size.height/2)
        addChild(label)
        
        let textFieldFrame = CGRect(origin: CGPoint(x: size.width/4, y: size.height/5), size: CGSize(width: 200, height: 30))
        let textField = UITextField(frame: textFieldFrame)
        textField.backgroundColor = UIColor.white
        textField.placeholder = "Name"
        
        textField.delegate = self
        
        view?.addSubview(textField)
   }
    
    func addScore(name: String) {
        scores.addScore(player: name, score: score)
    }
  
  required init(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

extension GameOverScene: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        addScore(name: textField.text!)
        return true
    }
}
