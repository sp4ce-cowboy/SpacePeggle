import SwiftUI

/// View of the action bar at the bottom that the user can interact with.
/// Having this class allows the entire bottom section of the Level designer to
/// be uniformly modifiable.
struct ActionBarView: View {
    @EnvironmentObject var viewModel: LevelSceneViewModel

    var adjustedHeight: Double { 0.0 }

    var body: some View {
        ZStack {
            VStack {
                Spacer()
                VStack {
                    SelectionBarView()
                    FunctionBarView()
                }
                .frame(width: Constants.UI_SCREEN_WIDTH,
                       height: Constants.getAdjustedActionBarHeight,
                       alignment: .bottom)
                .background(Color.white)
            }
        }
    }
}
