import Foundation
import SwiftUI

/// Abstract specification for a LevelDesigner that can be implemented by
/// any ViewModel. Having such an interface decouples the LevelDesigner
/// from the Level itself. This allows for the underlying Level to be
/// of any form, even dependence on AbstractLevel is not required, as
/// long as the interface specifications are fulfilled. 
protocol AbstractLevelDesigner {
    var levelObjects: [UUID: any GameObject] { get }
    var domain: CGRect { get set }

    func handleObjectResizing(_ value: DragGesture.Value, _ levelObject: any GameObject)
    func handleObjectAddition(_ object: any GameObject)
    func handleObjectRemoval(_ object: any GameObject)
    func updateObjectPosition(_ gameObject: any GameObject, with position: Vector)
    func handleObjectMovement(_ object: any GameObject, with drag: DragGesture.Value)
}

/// See PhysicsEngine and GameEngine
extension LevelDesigner: AbstractLevelDesigner { }

/// The level designer class encapsulates a Level and exposes certain methods
/// required for level manipulation
class LevelDesigner {

    var currentLevel: AbstractLevel
    var domain: CGRect = Constants.getDefaultFullScreen()
    var levelName: String { currentLevel.name }
    var levelObjects: [UUID: any GameObject] {
        get { currentLevel.gameObjects }
        set { currentLevel.updateLevel(newValue) }
    }

    init(currentLevel: AbstractLevel = LevelDesigner.getEmptyLevel(),
         domain: CGRect = Constants.getDefaultFullScreen()) {
        defer { Logger.log("LevelDesigner is initialized with \(levelName)", self) }

        self.currentLevel = currentLevel
        self.domain = domain
    }

    deinit {
        Logger.log("Level Designer is deinitialized with \(levelName)", self)
    }

    /// Returns an empty level
    static func getEmptyLevel() -> Level {
        Level(name: "LevelName", gameObjects: [:])
    }
}

/// This extension allows the LevelDesigner to handle tap gestures for
/// basic object creation.
extension LevelDesigner {
    func handleObjectAddition(_ object: any GameObject) {
        guard isValidPosition(object) && !isOverlapping(object) else {
            return
        }
        currentLevel.storeGameObject(object)
        Logger.log("GameObject \(object.gameObjectType) stored at \(object.centerPosition)", self)
    }

    private func isValidPosition(_ object: any GameObject) -> Bool {
        domain.containsAllVectors(object.edgeVectors)
    }

    private func isOverlapping(_ object: any GameObject) -> Bool {
        levelObjects.values
            .filter { $0.id != object.id }
            .contains { $0.overlap(with: object) != nil }
    }
}
