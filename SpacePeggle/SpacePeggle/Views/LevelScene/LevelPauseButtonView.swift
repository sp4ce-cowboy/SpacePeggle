import SwiftUI

struct LevelPauseButtonView: View {
    @EnvironmentObject var viewModel: LevelSceneViewModel

    var body: some View {
        if !viewModel.isLevelDesignerPaused {
            VStack {
                HStack {
                    Spacer() // Pushes the following items to the right
                    Button(action: { viewModel.handlePause() }) {
                        Image(systemName: "gearshape.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 40.0)
                            .foregroundStyle(Color.black)
                            .opacity(0.6)
                    }
                    .padding()
                }
                Spacer() // Pushes the VStack content towards the top
            }
        }
    }
}
