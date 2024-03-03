import SwiftUI

class LevelSceneViewModel: ObservableObject {

    @Published var isLevelDesignerPaused = false
    @Published var isLevelObjectSelected = false
    @Published var currentGameObject: UUID?
    var geometryState: GeometryProxy
    var selectedMode: Constants.LevelMode = .NormalPeg
    // var currentLevel: AbstractLevelAdvanced = Level(name: "LevelName", gameObjects: [:])
    var levelDesigner: AbstractLevelDesigner = LevelDesigner()
    // @Published var currentLevel: AbstractLevelAdvanced = LevelStub().getLevelStub()

    init(_ geometryState: GeometryProxy) {
        self.geometryState = geometryState
        levelDesigner.domain = Constants.getAdjustedGameArea()
    }

    deinit {
        Logger.log("ViewModel is deinitialized from \(self)", self)
    }

    var levelObjects: [UUID: any GameObject] {
        levelDesigner.levelObjects
    }

    var levelDomain: CGRect {
        levelDesigner.domain
    }

    func handlePause() {
        triggerRefresh()
        isLevelDesignerPaused.toggle()
    }

    func triggerRefresh() {
        DispatchQueue.main.async { self.objectWillChange.send() }
    }

}

/// This extension adds basic level object management abilities.
extension LevelSceneViewModel {

    func handleAreaTap(in location: CGPoint) {
        triggerRefresh()

        let locationVector = Vector(with: location)
        var gameObject: any GameObject = NormalPeg(centerPosition: locationVector)

        switch selectedMode {
        case .NormalPeg:
            gameObject = NormalPeg(centerPosition: locationVector)
        case .GoalPeg:
            gameObject = GoalPeg(centerPosition: locationVector)
        case .Block:
            break
        case .Remove:
            // return
            break
        }

        levelDesigner.handleObjectAddition(gameObject)
    }

    func handleLevelObjectRemoval(_ object: any GameObject) {
        triggerRefresh()
        Logger.log("LevelObject \(object.id) removed", self)
        // currentLevel.handleObjectRemoval(object)
        levelDesigner.handleObjectRemoval(object)
    }

    func handleLevelObjectMovement(_ object: any GameObject, with drag: DragGesture.Value) {
        triggerRefresh()
        // currentLevel.handleObjectMovement(object, with: drag)
        levelDesigner.handleObjectMovement(object, with: drag)
    }

}

/// This extension adds the ability for the rotation and scaling functionality.
extension LevelSceneViewModel {

    func handleDragGestureChange(_ value: DragGesture.Value, _ levelObject: any GameObject) {
        triggerRefresh()
        levelDesigner.handleObjectResizing(value, levelObject)

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
