import SwiftUI

struct MainView: View {
    /// StateObject becauses MainView owns this ViewModel
    @StateObject var viewModel: MainViewModel

    init(forGeometry geometryState: GeometryProxy) {
        _viewModel = StateObject(wrappedValue: MainViewModel(geometryState))
    }

    var body: some View {
        ZStack {
            GameAreaView()
            BallView()
            LauncherView()
            LevelView()
            PauseButtonView()
            if viewModel.isPaused {
                Rectangle()
                    .foregroundColor(.red)
                    .padding()
                    .frame(width: 400, height: 600)
                    .contentShape(Rectangle())
            }
        }
        .background {
            BackgroundView()
        }
        .environmentObject(viewModel)
        .onAppear {                     // Placeholder game starter for Problem Set 3
            viewModel.startGame()       // .onAppear modifier can be changed to .onAction
            Logger.log("game has started")   // or delegated to ViewModel if needed,
        }
        .onDisappear {
            viewModel.stopGame()
            Logger.log("game has stopped")
        }
    }

}

#Preview {
    GeometryReader { proxy in
        MainView(forGeometry: proxy)
    }
}
