//
//  GameUIView.swift
//  Final Project
//
//  Created by Dave & Muchlas BFF on 4/29/20.
//  Copyright © 2020 Dave & Muchlas BFF. All rights reserved.
//

import SwiftUI
import SpriteKit

struct GameUIView: View {
    var body: some View{
        ZStack {
            GameUIViewController()
            //.frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                .edgesIgnoringSafeArea(.all)
        }
    }
}

struct GameUIView_Previews: PreviewProvider {
    static var previews: some View {
        GameUIView()
    }
}
