//
//  LevelView.swift
//  PeggleGameplay
//
//  Created by Rubesh on 18/2/24.
//

import SwiftUI

struct LevelView: View {
    @EnvironmentObject var viewModel: MainViewModel

    var body: some View {
        ForEach(Array(viewModel.gameObjects.keys), id: \.self) { id in
            if let gameObject = viewModel.gameObjects[id] {
                GameObjectView(gameObject: gameObject)
            }
        }
    }
}
