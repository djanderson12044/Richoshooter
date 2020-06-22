//
//  Model.swift
//  Final Project
//
//  Created by Hayden on 4/19/20.
//  Copyright © 2020 Dave & Muchlas BFF. All rights reserved.
//

import Foundation

struct Score : Identifiable{
    var id = UUID()
    
    var player:String
    var score:Int
    var rank:Int
}

class HighScoreManager {
    
    //array of scores
    var highScores : [Score] = []
    
    func addScore(player: String, score: Int) {
        let newScore = Score(player: player, score: score, rank: 0)
        highScores.append(newScore)
        print("Score hath been added")
        print(player)
        print(score)
    }
    
    //Returns an array of scores in order from greatest to least
    func getHighScores() -> [Score] {
        //should be sorted = highScores.sorted...
        var sorted = highScores.sorted { (lhs, rhs) -> Bool in
            return lhs.score > rhs.score
        }
        
        for(index, var _) in sorted.enumerated() {
            sorted[index].rank = index + 1
        }
        
        return sorted
    }
}
