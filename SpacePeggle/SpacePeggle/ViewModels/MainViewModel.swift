import SwiftUI

protocol GameEngineDelegate: AnyObject {
    func processActiveGameObjects(withID id: UUID)
}

class MainViewModel: ObservableObject, GameEngineDelegate {

    @Published var gameObjectOpacities: [UUID: Double] = [:]
    var peggleGameEngine: AbstractGameEngine
    var geometryState: GeometryProxy
    var currentViewSize: CGSize { geometryState.size }
    var isPaused = true

    init(_ geometryState: GeometryProxy) {
        self.geometryState = geometryState
        self.peggleGameEngine = GameEngine(geometry: geometryState)
        peggleGameEngine.delegate = self
        setupDisplayLink()
    }

    /// The main liasion between the game objects renderer and the game engine that
    /// contains game objects. The penultimate function for all final UI renderings.
    /// Pre-sorting ensures that the dictionary values are only sorted when needed
    var gameObjects: [UUID: any GameObject] {
        peggleGameEngine.gameObjects
    }

    func processActiveGameObjects(withID id: UUID) {
        withAnimation(.easeOut(duration: Constants.TRANSITION_INTERVAL)) {
            gameObjectOpacities[id] = 0
        }
        // After the fade-out duration, remove the GameObject from the dictionary
        // DispatchQueue.main.asyncAfter(deadline: .now() + Constants.TRANSITION_INTERVAL) {
        //    self.gameObjectOpacities[id] = nil
        // }
    }

    func handlePause() {
        isPaused.toggle()
    }

}