import SwiftUI

class StartSceneViewModel: ObservableObject {
    @Published var currentMenuState: Enums.MenuState = .MainMenu
    var sceneController: AppSceneController
    var geometryState: GeometryProxy

    init(_ geometryState: GeometryProxy, _ sceneController: AppSceneController) {
        self.geometryState = geometryState
        self.sceneController = sceneController
    }

    private func triggerRefresh() {
        DispatchQueue.main.async { self.objectWillChange.send() }
    }

    /// Using a dictionary allows for greater scalability than Enums
    /// But having Enums as the keys allows for stricter input control
    private var menuCollection: [Enums.MenuState: () -> AnyView] = [
        .MainMenu: { AnyView(StartMenuDefaultView()) },
        .LevelSelectionMenu: { AnyView(LevelSelectionMenuView()) },
        .SettingsMenu: { AnyView(StartSettingsMenuView()) },
        .PowerUpMenu: { AnyView(PowerUpSettingsView()) },
        .EnvironmentMenu: { AnyView(EnvironmentMenuView()) }
    ]

    @ViewBuilder
    func getCurrentMenu() -> some View {
        if let viewClosure = menuCollection[currentMenuState] {
            viewClosure()
        } else {
            StartMenuDefaultView()
        }
    }
}

/// Extension for default start menu
extension StartSceneViewModel {
    func handleStartGameButton() {
        // triggerRefresh()
        currentMenuState = .LevelSelectionMenu
    }

    func handleLoadLevelButton() {
        /// Open files
    }

    func handleDesignButton() {
        sceneController.transitionToLevelScene()
    }

    func handleSettingsButton() {
        currentMenuState = .SettingsMenu
    }

}

/// Extension for level selection menu
extension StartSceneViewModel {

    func handleLoadLevelOne() {
        sceneController.transitionToGameScene(with: LevelStub().getLevelOneStub())
    }

    func handleLoadLevelTwo() {
        sceneController.transitionToGameScene(with: LevelStub().getLevelTwoStub())
    }

    func handleLoadLevelThree() {
        sceneController.transitionToGameScene(with: LevelStub().getLevelThreeStub())
    }

    func handleReturnButton() {
        currentMenuState = .MainMenu
    }

}

/// Extension for settings sub menu
extension StartSceneViewModel {

    func handleGravityButton() {

    }

    func handleEnvironmentButton() {
        currentMenuState = .EnvironmentMenu
    }

    func handleGamePowerUpButton() {
        currentMenuState = .PowerUpMenu
    }

    func handleKaboomButton() {
        Constants.UNIVERSAL_POWER_UP = .Kaboom
    }

    func handleSpookyButton() {
        Constants.UNIVERSAL_POWER_UP = .Spooky
    }

    func handleReturnToSettingsButton() {
        currentMenuState = .SettingsMenu
    }

    func handleGetCurrentPowerUp() -> String {
        triggerRefresh()
        return Constants.UNIVERSAL_POWER_UP.rawValue
    }

}

/// Extension for settings sub menu
extension StartSceneViewModel {

    func handleEarth() {
        triggerRefresh()
        Constants.BACKGROUND_IMAGE = .Earth
        Constants.UNIVERSAL_GRAVITY = Vector(x: 0, y: 1_000)
    }

    func handleSaturn() {
        triggerRefresh()
        triggerRefresh()
        Constants.BACKGROUND_IMAGE = .Saturn
        Constants.UNIVERSAL_GRAVITY = Vector(x: 0, y: 2_500)
    }

    func handleMars() {
        triggerRefresh()
        Constants.BACKGROUND_IMAGE = .Mars
        Constants.UNIVERSAL_GRAVITY = Vector(x: 0, y: 700)
    }

    func handleSpace() {
        triggerRefresh()
        Constants.BACKGROUND_IMAGE = .Space
        Constants.UNIVERSAL_GRAVITY = Vector(x: 0, y: 300)
    }
}
