import SwiftUI

class LevelSceneViewModel: ObservableObject {

    @Published var isPaused = false
    var geometryState: GeometryProxy
    var selectedGameObject: Constants.GameObjectType = .NormalPeg
    var currentLevel: AbstractLevelAdvanced = Level(name: "LevelName", gameObjects: [:])

    init(_ geometryState: GeometryProxy) {
        self.geometryState = geometryState
    }

    deinit {
        Logger.log("ViewModel is deinitialized from \(self)", self)
    }

    var levelObjects: [UUID: any GameObject] {
        currentLevel.gameObjects
    }

    func handlePause() {
        isPaused.toggle()
    }

    func triggerRefresh() {
        DispatchQueue.main.async { self.objectWillChange.send() }
    }

}

/// This extension adds level object management abilities to the
/// view model.
extension LevelSceneViewModel {

    func handleAreaTap(in location: CGPoint) {
        triggerRefresh()

        let locationVector = Vector(with: location)
        var gameObject: any GameObject = NormalPeg(centerPosition: locationVector)

        switch selectedGameObject {
        case .NormalPeg:
            gameObject = NormalPeg(centerPosition: locationVector)
        case .GoalPeg:
            gameObject = GoalPeg(centerPosition: locationVector)
        case .Block:
            break
        }

        currentLevel.storeGameObject(gameObject)
        Logger.log("GameObject \(selectedGameObject) stored at \(locationVector)", self)
        Logger.log("Level now contains \(currentLevel.gameObjects.keys.count) items", self)
    }

    func handleLevelObjectRotation(_ view: LevelObjectView, angle: Angle) {
        currentLevel.handleObjectRotation(id: view.levelObject.id, value: angle)
    }

    func handleLevelObjectMagnification(_ view: LevelObjectView, scale: Double) {
        currentLevel.handleObjectMagnification(id: view.levelObject.id, scale: scale)
    }

    func handleLevelObjectRemoval(_ view: LevelObjectView) {
        currentLevel.handleObjectRemoval(id: view.levelObject.id)
    }

}

protocol PegManipulation {
    func handleTap(in location: CGPoint, for geometry: GeometryProxy)
    func handleLongPress(forPegAt index: Int)

    // Should be handled by LevelModel
    func addPeg(at location: CGPoint, for geometry: GeometryProxy, withColor: Color)
    func movePegPermanently(at index: Int, from startLocation: CGPoint,
                            to endLocation: CGPoint, for geometry: GeometryProxy)
    func removePeg(at index: Int)
}

protocol PegValidation {
    func isValidLocation(_ location: CGPoint, _ geometry: GeometryProxy) -> Bool
    func isValidLocationForMoving(_ location: CGPoint, _ geometry: GeometryProxy, _ index: Int) -> Bool

    // Should be handled by universal collider
    func isWithinPlayableArea(_ location: CGPoint, _ geometry: GeometryProxy) -> Bool
    func isOverlapping(_ location: CGPoint) -> Bool
    func isOverlappingExclusively(_ location: CGPoint, index: Int) -> Bool
}

protocol GameStateManagement {
    var isRemove: Bool { get set }
    var levelNameInput: String { get set }
}

typealias AbstractLevelSceneViewModel =
ObservableObject & PegManipulation & PegValidation & GameStateManagement
