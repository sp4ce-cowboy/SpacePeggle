import SwiftUI

struct CircleShape: PhysicsShape {
    var center: Vector
    var radius: Double
    var width: Double {
        get { radius }
        set { radius = newValue }
    }
    var height: Double {
        get { radius }
        set { radius = newValue }
    }

}

/// Adding each intersection as an extension for each shape ensures
/// that more PhysicsShapes can be added without the Open-closed principle
/// being violated.
///
/// For problem set 3, since both Ball and Peg are of CircleShape, circle-circle
/// intersection alone is sufficient.
extension CircleShape {
    func intersects(with shape: PhysicsShape) -> Bool {
        if let circle = shape as? CircleShape {
            return self.intersects(with: circle)
        }
        return false
    }

    func intersects(with circle: CircleShape) -> Bool {
        let distance = (self.center - circle.center).magnitude
        return distance < (self.radius + circle.radius)
        // return overlap
        /*if overlap {
            return ((self.radius + circle.radius) - distance) / 2
        } else {
            return nil
        }*/
    }
}
