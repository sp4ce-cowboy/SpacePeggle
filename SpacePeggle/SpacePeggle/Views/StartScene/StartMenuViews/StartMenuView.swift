import SwiftUI

struct StartMenuView: View {
    @EnvironmentObject var viewModel: StartSceneViewModel
    var currentMenu: Enums.MenuState { viewModel.currentMenuState }

    /// Similar to the AppSceneController, there is a mini scene controller here
    /// to simplify transition between menu screens.
    var body: some View {
        viewModel
            .getCurrentMenu()
            .environmentObject(viewModel)
    }
}
