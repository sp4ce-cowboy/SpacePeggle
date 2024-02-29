//
//  StartMenuView.swift
//  SpacePeggle
//
//  Created by Rubesh on 29/2/24.
//

import SwiftUI

struct StartMenuView: View {
    var body: some View {
        VStack {
            Spacer()
            Spacer()

            Text("🪐 SPACE PEGGLE 🪐")
                .font(.system(size: StyleSheet.getScaledWidth(4.5)))
                .fontDesign(.monospaced)
                .fontWeight(.heavy)
                .foregroundStyle(Color.white)
                .padding()

            Spacer()

            StyleSheet.getRectangleButtonWithAction(
                text: "LOAD LEVEL",
                action: { AppSceneController.shared.transitionToGameScene() })

            StyleSheet.getRectangleButtonWithAction(
                text: "DESIGN LEVEL",
                action: { AppSceneController.shared.transitionToLevelScene() })

            StyleSheet.getRectangleButtonWithAction(
                text: "SETTINGS",
                action: { AppSceneController.shared.transitionToGameScene() })

            Spacer()
        }
    }
}

#Preview {
    StartMenuView()
}
