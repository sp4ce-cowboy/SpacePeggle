import Foundation
import SwiftUI

/// The` AbstractPhysicsEngine` protocol is the interface between any existing GameEngine
/// and the Physics Engine. This way, the Game Engine is not dependent on the
/// Physics Engine used, and vice versa. Any Physics Engine that conforms to this
/// protocol can be used for any Game Engine
///
/// This means that any Game Engine is completed decoupled from any concrete
/// implementation of Physics Engine.
///
/// Also see `AbstractGameEngine`
protocol AbstractPhysicsEngine {
    var delegate: PhysicsEngineDelegate? { get set }
    var physicsObjects: [UUID: any PhysicsObject] { get set }
    var domain: CGRect { get set }
    var isDomainExpansionActive: Bool { get set }
    func addPhysicsObject(object: any PhysicsObject)
    func removeObject(with id: UUID)
    func updatePhysics(timeStep: TimeInterval)

    init(domain: CGRect, physicsObjects: [UUID: any PhysicsObject])
}
