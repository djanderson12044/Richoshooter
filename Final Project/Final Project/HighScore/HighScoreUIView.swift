//
//  ContentView.swift
//  Final Project
//
//  Created by Dave & Muchlas BFF on 4/15/20.
//  Copyright © 2020 Dave & Muchlas BFF. All rights reserved.
//

import SwiftUI

var scores = HighScoreManager()
var highScores = scores.getHighScores()

struct HighScoreUIView: View {
    var body: some View {
        
        VStack(alignment: .center) {
            
            Text("High Scores")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.top)
            
            List(highScores) { item in
                Text("\(item.rank)")
                    .fontWeight(.semibold)
                    .foregroundColor(Color(red: 0.0, green: 0.0, blue: 0.0, opacity: 0.5))
                    .padding(.horizontal)
                    .frame(width: 50.0)
                    
                HStack {
                    Text(item.player)
                        .fontWeight(.semibold)
                        .frame(width: 50.0)
                    Text("\(item.score)")
                }
            }
            .padding(.horizontal)
        }
    }
}

struct HighScoreUIView_Previews: PreviewProvider {
    static var previews: some View {
        HighScoreUIView()
    }
}
