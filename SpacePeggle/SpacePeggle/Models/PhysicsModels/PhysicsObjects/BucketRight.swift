import SwiftUI

/// The Bucket model extends the PhysicsObject protocol
final class BucketRight: PhysicsObject {

    weak var bucket: Bucket?

    static let DEFAULT_HEIGHT: Double =
    Double(ObjectSet.defaultGameObjectSet["Bucket"]?.size.height ??
           CGFloat(Constants.UNIVERSAL_LENGTH))

    static let DEFAULT_WIDTH: Double =
    Double(ObjectSet.defaultGameObjectSet["Bucket"]?.size.width ??
           CGFloat(Constants.UNIVERSAL_LENGTH))

    static let DEFAULT_SHAPE = RectangularShape(height: DEFAULT_HEIGHT,
                                                width: DEFAULT_WIDTH / 15)

    static let DEFAULT_CENTER = Vector(x: Constants.UI_SCREEN_WIDTH.half
                                       + DEFAULT_WIDTH.half
                                       - DEFAULT_SHAPE.width.half,
                                       y: Constants.UI_SCREEN_HEIGHT - DEFAULT_HEIGHT.half)



    var velocity: Vector {
        get { bucket?.velocity ?? .zero }
        set { bucket?.velocity = newValue }
    }

    var id = UUID()
    var mass: Double = .infinity
    var centerPosition: Vector
    var force: Vector = .zero
    var shape: UniversalShape = BucketRight.DEFAULT_SHAPE
    var isSubjectToGravity = false

    init(shape: UniversalShape = BucketRight.DEFAULT_SHAPE) {
        self.shape = shape
        self.centerPosition = BucketRight.DEFAULT_CENTER
    }

    func updatePosition(to finalLocation: Vector) {
        self.centerPosition = finalLocation
        // self.shape.center = self.centerPosition
    }

    func applyPhysics(timeStep: TimeInterval) {
        applyVelocityOnPosition(timeStep: timeStep)
    }

    func applyVelocityOnPosition(timeStep: TimeInterval) {
        let newPosition = centerPosition + (velocity * timeStep)
        updatePosition(to: newPosition)
    }

    func applyRestitution() {

    }

}
