//
//  MainMenuSwiftUI.swift
//  Final Project
//
//  Created by Dave & Muchlas BFF on 5/10/20.
//  Copyright © 2020 Dave & Muchlas BFF. All rights reserved.
//

import SwiftUI

struct MainMenuSwiftUI: View {
  @State var showDetails = false
    var body: some View {
         NavigationView {
            ZStack {
                //setting background to be the entire screen by ignoring safe area
                Image("Stars_Background")
                    .resizable()
                    .edgesIgnoringSafeArea(.all)

                VStack {
                    Image("ricoshooter")
                        .resizable()
                        .frame(width: 300, height:75)
                        Spacer()
                    NavigationLink(destination: GameUIView()) {
                        Image("startgame")
                    }
                    NavigationLink(destination: HighScoreUIView()) {
                        Image("highscore").renderingMode(.original)
                    }
                }
            }
        }
    }

}

struct ButtonView: View {
var body: some View {
    Image("highscore")
}
}

struct MainMenuUIView_Previews: PreviewProvider {
    static var previews: some View {
        MainMenuSwiftUI()
    }
}

