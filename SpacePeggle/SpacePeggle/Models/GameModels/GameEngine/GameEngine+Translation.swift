import SwiftUI

/// This extension adds object translation ability to `Engine`, operations
/// that involve synchronizing physics objects with game objects and vice versa.
extension GameEngine {

    /// One way translation from `PhysicsObjects` to `GameObjects`.
    ///
    /// Iterates over the collection of physics objects inside the physics engine
    /// and updates the collection of game objects accordingly. Due to the way swift
    /// handles reference types like classes, casting physics objects (that are also
    /// game objects) to game objects do not result in information loss (as long as
    /// the conforming types are classes).
    ///
    /// - Requires: Pre-populated collection of physics objects. No side-effect otherwise.
    func updateGameObjectState() {
        for (id, physicsObject) in physicsEngine.physicsObjects {
            guard let physicsObjectAsGameObject = physicsObject as? (any GameObject) else {
                continue // Skip to the next iteration if the cast fails
            }
            gameObjects[id] = physicsObjectAsGameObject
        }
    }

    /// One-way translation from game objects to physics objects.
    ///
    /// This can be useful when trying to load physics objects from a set
    /// of game objects during loading of a new level.
    ///
    /// - Requires: Pre-populated collection of game objects. No side-effect otherwise.
    func updatePhysicsObjectsFromGameObjects() {
        for gameObject in gameObjects.values {
            guard let physicsObject = gameObject as? (any PhysicsObject) else {
                continue
            }
            physicsObjects[gameObject.id] = physicsObject

        }
    }

    /// One-way translation from physics objects to game objects.
    ///
    /// - Requires: Pre-populated collection of game objects. No side-effect otherwise.
    func updateGameObjectsFromPhysicsObjects() {
        for physicsObject in physicsObjects.values {
            guard let gameObject = physicsObject as? (any GameObject) else {
                continue
            }
            gameObjects[physicsObject.id] = gameObject

        }
    }

}
