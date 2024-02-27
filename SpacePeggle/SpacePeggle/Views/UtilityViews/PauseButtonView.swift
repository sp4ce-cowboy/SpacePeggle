//
//  PauseButtonView.swift
//  PeggleGameplay
//
//  Created by Rubesh on 25/2/24.
//

import SwiftUI

struct PauseButtonView: View {
    @EnvironmentObject var viewModel: MainViewModel

    var body: some View {
        VStack {
            HStack {
                Spacer() // Pushes the following items to the right
                Button(action: {
                    viewModel.handlePause()
                }) {
                    Image(systemName: viewModel.isPaused
                          ? "play.circle.fill"
                          : "pause.circle.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 40.0)
                    .foregroundStyle(Color.green)

                }
                .padding()
                // .disabled(viewModel.isPaused)
            }
            Spacer() // Pushes the VStack content towards the top
        }
    }
}
