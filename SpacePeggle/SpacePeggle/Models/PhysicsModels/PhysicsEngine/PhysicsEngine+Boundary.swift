import SwiftUI

/// Adds boundary collision resolution to the Physics Engine.
extension PhysicsEngine {

    /*func handleBoundaryCollision(object: inout any PhysicsObject) {
        let screenBounds = domain.size

        // Check for left or right boundary collision
        // TODO: add object widths here!
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
    }*/

    /// Handling boundary collisions separately ensures an accurate and realistic
    /// depiction of physics objects, as opposed to if they were treated merely
    /// as planes or lines.
    func handleBoundaryCollision(object: inout any PhysicsObject) {
        let objectX = object.centerPosition.x
        let objectY = object.centerPosition.y
        let widthX = object.width.half
        let heightY = object.height.half

        let screenBounds = domain.size
        let screenXStart = domain.origin.x
        let screenYStart = domain.origin.y
        let screenXEnd = screenBounds.width + screenXStart
        let screenYEnd = screenBounds.height + screenYStart

        // Check for left or right boundary collision
        if objectX < (screenXStart + widthX) || objectX > (screenXEnd - widthX) {
            if objectX < (screenXStart + widthX) {
                object.centerPosition.x = (screenXStart + widthX)
            }
            if objectX > (screenXEnd - widthX) {
                object.centerPosition.x = (screenXEnd - widthX)
            }
            object.velocity.x.negate()
            object.velocity.x *= restitution
        }

        // Check for top collision only
        if objectY < (screenYStart + heightY) {
            if objectY < (screenYStart + heightY) {
                object.centerPosition.y = (screenYStart + heightY)
                // if domainConstraint is true then dont need
            }

            object.velocity.y.negate()
            object.velocity.y *= restitution
        }
    }
}
