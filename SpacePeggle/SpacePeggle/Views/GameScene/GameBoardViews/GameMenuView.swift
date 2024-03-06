//
//  MenuView.swift
//  SpacePeggle
//
//  Created by Rubesh on 27/2/24.
//

import SwiftUI

struct GameMenuView: View {
    @EnvironmentObject var viewModel: GameSceneViewModel

    var body: some View {
        ZStack {
            StyleSheet
                .getRectangleOverlay()
                .overlay {

                    VStack {
                        getMenuButtonForGravity(
                            text: "Set Gravity to Zero",
                            value: Vector(x: 0, y: 0))

                        getMenuButtonForGravity(
                            text: "Set Gravity to Earth",
                            value: Vector(x: 0, y: 981))

                        getMenuButtonForGravity(
                            text: "Set Gravity to Jupiter",
                            value: Vector(x: 0, y: 9_810))

                        StyleSheet.getRectangleButtonWithAction(
                            text: "RETURN TO GAME",
                            action: { viewModel.handleReturnButton() })

                        StyleSheet.getRectangleButtonWithAction(
                            text: "EXIT TO MENU",
                            action: {
                                viewModel.handleExitButton()
                            })
                        .foregroundColor(Color.red)

                    }
                }
        }

    }

    func getMenuButtonForGravity(text: String, value: Vector) -> some View {
        Button(action: { Constants.UNIVERSAL_GRAVITY = value },
               label: { StyleSheet.getRectangleWithText(text: text) })
    }
}
