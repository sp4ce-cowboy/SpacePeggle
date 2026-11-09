import SwiftUI

/// Adds boundary collision resolution to the Physics Engine.
extension PhysicsEngine {

    /// Handling boundary collisions separately ensures an accurate and realistic
    /// depiction of physics objects, as opposed to if they were treated merely
    /// as planes or lines.
    func handleBoundaryCollision(object: inout any PhysicsObject) {
        let screenBounds = domain.size

        // Check for left or right boundary collision
        if object.centerPosition.x <= 0 || object.centerPosition.x >= screenBounds.width {
            if object.centerPosition.x < 0 {
                object.centerPosition.x = 0
            }
            if object.centerPosition.x > screenBounds.width {
                object.centerPosition.x = screenBounds.width
            }
            object.velocity.x.negate()
            object.velocity.x *= restitution
        }

        // Check for top boundary collision only, bottom boundary is open
        if object.centerPosition.y <= 0 {
            object.centerPosition.y = 0

            object.velocity.y.negate()
            object.velocity.y *= restitution
        }
    }
}
