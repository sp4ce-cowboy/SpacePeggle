import SwiftUI

/*
struct CircleShape: UniversalShape {
    var rotation: Angle
    
    var scale: Double
    
    func intersects(with shape: UniversalShape) -> Bool {
        <#code#>
    }
    
    init(height: Double, width: Double, rotation: Angle, scale: Double) {
        <#code#>
    }
    
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
*/

/// Adding each intersection as an extension for each shape ensures
/// that more PhysicsShapes can be added without the Open-closed principle
/// being violated.
///
/*
extension CircleShape {
    func intersects(with shape: UniversalShape) -> Bool {
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
*/
