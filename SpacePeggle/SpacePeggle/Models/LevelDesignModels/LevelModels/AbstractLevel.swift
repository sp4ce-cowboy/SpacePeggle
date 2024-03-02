import SwiftUI

/// AbstractLevel protocol that Level conforms to, so that AbstractGameEngine
/// (and by corollary, any conforming types) are decoupled from the Level class.
protocol AbstractLevel {
    var name: String { get }
    var gameObjects: [UUID: any GameObject] { get set }

    init(name: String, gameObjects: [UUID: any GameObject])

    func getGameObject(id: UUID) -> (any GameObject)?
    func storeGameObject(_ gameObject: any GameObject)
}

/// This protocol allows for the Level Designer to have access to more advanced
/// controls that are required for proper level designing functionality, but
/// not required by GameEngine.
///
/// In line with the Interface Segregation principle that states that no client
/// should be dependent on functionality they do not require, the methods specified
/// below are those that are only required by the Level Model for level designing.
///
/// Note: The term "Advanced" refers to the additional abilities added, not an improvement
/// over the current AbstractLevel's existing functionality.
protocol AbstractLevelAdvanced: AbstractLevel {
    func handleObjectRotation(id: UUID, value: Angle)
    func handleObjectMagnification(id: UUID, scale: Double)
    func handleObjectRemoval(id: UUID)
    func updateObjectPosition(id: UUID, with position: Vector)
    func updateObjectPosition(_ gameObject: any GameObject, with position: Vector)
    func handleObjectMovement(_ object: any GameObject, with drag: DragGesture.Value)
}
