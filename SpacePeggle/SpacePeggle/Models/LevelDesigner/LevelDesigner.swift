import Foundation
import SwiftUI

/// Abstract specification for a LevelDesigner that can be implemented by
/// any ViewModel. Having such an interface decouples the LevelDesigner
/// from the Level itself. This allows for the underlying Level to be
/// of any form, even dependence on AbstractLevel is not required, as
/// long as the interface specifications are fulfilled.
protocol AbstractLevelDesigner {
    var levelObjects: [UUID: any GameObject] { get }
    var levelName: String { get set }
    var domain: CGRect { get set }

    func clearLevel()
    func loadLevel(with level: AbstractLevel)
    func handleObjectResizing(_ value: DragGesture.Value, _ levelObject: any GameObject)
    func handleObjectAddition(_ object: any GameObject)
    func handleObjectRemoval(_ object: any GameObject)
    func handleObjectRemoval(_ location: Vector)
    func updateObjectPosition(_ gameObject: any GameObject, with position: Vector)
    func handleObjectMovement(_ object: any GameObject,
                              with drag: DragGesture.Value,
                              and state: inout Bool)
    func updateObjectHitPoints(withId id: UUID, and value: Int)
    func getOpacity(for id: UUID) -> Double
    func getCounter() -> Counter
}

/// See PhysicsEngine and GameEngine
extension LevelDesigner: AbstractLevelDesigner { }

/// The level designer class encapsulates a Level and exposes certain methods
/// required for level manipulation
class LevelDesigner {

    var currentLevel: AbstractLevel
    var domain: CGRect = Constants.getAdjustedGameArea()
    var counter = Counter()
    var levelName: String {
        get { currentLevel.name }
        set { currentLevel.name = newValue }
    }
    var levelObjects: [UUID: any GameObject] {
        get { currentLevel.gameObjects }
        set { currentLevel.updateLevel(fromDictionary: newValue) }
    }

    init(currentLevel: AbstractLevel = LevelDesigner.getEmptyLevel(),
         domain: CGRect = Constants.getAdjustedGameArea()) {
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

    func clearLevel() {
        currentLevel.gameObjects.removeAll()
    }

    func loadLevel(with level: AbstractLevel) {
        currentLevel = level
    }

    func getCounter() -> Counter {
        updateCounter()
        return self.counter
    }

    private func updateCounter() {
        counter.normalPegCount = levelObjects.values.filter { $0.gameObjectType == .NormalPeg }.count
        counter.goalPegCount = levelObjects.values.filter { $0.gameObjectType == .GoalPeg }.count
        counter.spookyPegCount = levelObjects.values.filter { $0.gameObjectType == .SpookyPeg }.count
        counter.kaboomPegCount = levelObjects.values.filter { $0.gameObjectType == .KaboomPeg }.count
        counter.blockCount = levelObjects.values.filter { $0.gameObjectType == .BlockPeg }.count
        counter.stubbornPegCount = levelObjects.values.filter { $0.gameObjectType == .StubbornPeg }.count
    }
}

/// This extension allows the LevelDesigner to handle tap gestures for
/// basic object creation and removal
extension LevelDesigner {
    func handleObjectAddition(_ object: any GameObject) {
        guard isValidPosition(object) && !isOverlapping(object) else {
            return
        }
        currentLevel.storeGameObject(object)
        Logger.log("GameObject \(object.gameObjectType) stored at \(object.centerPosition)", self)
    }

    private func isValidPosition(_ object: any GameObject) -> Bool {
        domain.containsAllVectors(object.sideVectors)
    }

    private func isOverlapping(_ object: any GameObject) -> Bool {
        levelObjects.values
            .filter { $0.id != object.id }
            .contains { $0.overlap(with: object) != nil }
    }

    func handleObjectRemoval(_ object: any GameObject) {
        levelObjects.removeValue(forKey: object.id)
    }

    func handleObjectRemoval(_ location: Vector) {
        if let object = levelObjects.values.first(where: { $0.contains(location) }) {
            handleObjectRemoval(object)
        }
    }
}

/// This extension allows for the modification of the hitpoints of game objects
extension LevelDesigner {

    func updateObjectHitPoints(withId id: UUID, and value: Int) {
        if let levelObject = levelObjects[id] {
            if levelObject.hp == Constants.MIN_HP_VALUE, value < .zero {
                return
            }

            if levelObject.hp == Constants.MAX_HP_VALUE, value > .zero {
                return
            }

            levelObjects[id]?.hp += value
        }
    }

    /// Returns the opacity depending on a game object's ability to be activated
    func getOpacity(for id: UUID) -> Double {
        guard let object = levelObjects[id] else {
            return StyleSheet.HALF_OPACITY
        }

        switch object.gameObjectType {
        case .BlockPeg, .StubbornPeg:
            return StyleSheet.HALF_OPACITY
        default:
            return StyleSheet.FULL_OPACITY
        }
    }
}
