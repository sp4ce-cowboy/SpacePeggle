import SwiftUI

struct StartMenuView: View {
    @EnvironmentObject var viewModel: StartSceneViewModel
    var currentMenu: Enums.MenuState { viewModel.currentMenuState }

    var body: some View {
        viewModel
            .getCurrentMenu()
            .environmentObject(viewModel)
    }
}
