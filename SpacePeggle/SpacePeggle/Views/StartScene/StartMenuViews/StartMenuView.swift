//
//  StartMenuView.swift
//  SpacePeggle
//
//  Created by Rubesh on 29/2/24.
//

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
