import SwiftUI

/// An externally imposed conformance allows for an intermediate avenue
/// to conform to what is required by a GameImplementation.
///
/// Essentially, the PhysicsEngine can be modified, and any incongruencies
/// can be sorted out within this extension. This way, the PhysicsEngine
/// can function as a standalone physics engine, and can accomodate designs
/// that might not fit with whatever the Game Implementation might require.
///
/// However, this externally imposed extension can be used as a space to
/// "reconfigure" the PhysicsEngine to conform with AbstractPhysicsEngine
/// that is required for a AbstractGameEngine. Basically, Physics Engine
/// can be its own thing, and if it needs to be used specifically for
/// a concrete Game Engine, this extension space can be used to make
/// accomodations for that.
///
/// Also see `GameEngine`
extension PhysicsEngine: AbstractPhysicsEngine { }

/// The PhysicsEngine class encapsulates oversees all Physics objects within a
/// given context. For the purposes of this problem set, this context is a 2D
/// world with a collection of `PhysicsObject` instances.
///
/// Any external client can utilize this Physics Engine by manipulating the
/// contained PhysicsObjects and updating them based on a provided time interval.
/// In this implementation, the physics engine is completely decoupled from any
/// specific or global "time-keeping" means, thus, every physics interaction
/// is determined discretely for the time interval provided through the
/// `updatePhysics` function, which can differ between calls.
///
/// Making the Physics Engine final prevents any sub-classing and overriding
/// of core physics elements that are needed to work together. To apply different
/// sets of Physics rules, a new Physics Implementation conformant must be created.
final class PhysicsEngine {
    let gravity = Constants.UNIVERSAL_GRAVITY
    let velocityCutOff = Constants.VELOCITY_CUTOFF
    let restitution = Constants.UNIVERSAL_RESTITUTION

    /// The area monitored by the Engine.
    var domain: CGRect

    var physicsObjects: [UUID: any PhysicsObject]

    init(areaOfEffect: CGRect, physicsObjects: [UUID: any PhysicsObject] = [:]) {
        self.physicsObjects = physicsObjects
        self.domain = areaOfEffect
    }

    func addPhysicsObject(object: any PhysicsObject) {
        self.physicsObjects[object.id] = object
    }

    func updatePhysics(timeStep: TimeInterval) {
        detectAndHandleCollisions()
        for key in physicsObjects.keys {
            if var physicsObject = physicsObjects[key] {
                physicsObject.applyPhysics(timeStep: timeStep)
                handleBoundaryCollision(object: &physicsObject)
            }
        }
    }
}