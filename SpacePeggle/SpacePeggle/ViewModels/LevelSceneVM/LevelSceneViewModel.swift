import SwiftUI

class LevelSceneViewModel: ObservableObject {
    @Published var isLevelDesignerPaused = false
    @Published var isLevelObjectSelected = false
    @Published var currentGameObject: UUID?
    var geometryState: GeometryProxy
    @Published var selectedMode: Enums.SelectedMode = .NormalPeg
    var hasCollided = false
    var levelDesigner: AbstractLevelDesigner = LevelDesigner()
    var levelNameInput: String = ""

    init(_ geometryState: GeometryProxy) {
        self.geometryState = geometryState
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
        case .BlockPeg:
            gameObject = BlockPeg(centerPosition: locationVector)
        case .SpookyPeg:
            gameObject = SpookyPeg(centerPosition: locationVector)
        case .KaboomPeg:
            gameObject = KaboomPeg(centerPosition: locationVector)
        case .StubbonPeg:
            gameObject = StubbornPeg(centerPosition: locationVector)
        case .Remove:
            levelDesigner.handleObjectRemoval(locationVector)
            return
        }

        levelDesigner.handleObjectAddition(gameObject)
    }

    func handleLevelObjectRemoval(_ object: any GameObject) {
        triggerRefresh()
        Logger.log("LevelObject \(object.id) removed", self)
        levelDesigner.handleObjectRemoval(object)
    }

    func handleLevelObjectMovement(_ object: any GameObject,
                                   with drag: DragGesture.Value) {
        triggerRefresh()
        levelDesigner.handleObjectMovement(object, with: drag, and: &hasCollided)
    }
}

/// This extension adds the ability for the rotation and scaling functionality.
extension LevelSceneViewModel {
    func handleDragGestureChange(_ value: DragGesture.Value, _ levelObject: any GameObject) {
        triggerRefresh()
        levelDesigner.handleObjectResizing(value, levelObject)
    }
}
