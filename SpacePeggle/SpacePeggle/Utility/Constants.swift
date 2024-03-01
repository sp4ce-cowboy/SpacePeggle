import SwiftUI

/// A universal source of truth and control for certain application wide configurations
/// and properties. Also includes some universal utility methods.
public class Constants {

    /// Universally declared screen size
    static var UI_SCREEN_SIZE: CGSize = UIScreen.currentSize

    /// Universally declared screen width
    static var UI_SCREEN_WIDTH: Double = UIScreen.currentSize.width

    /// Universally declared screen height
    static var UI_SCREEN_HEIGHT: Double = UIScreen.currentSize.height

    /// Universally declared object diameter
    static let UNIVERSAL_LENGTH: Double = UI_SCREEN_SIZE.height / 25.0

    /// Universally declared unit mass
    static let UNIT_MASS: Double = 1.0

    /// Universally declared velocity cut-off
    static let VELOCITY_CUTOFF: Double = 20.0

    /// Universally declared gravitational field strength
    static var UNIVERSAL_GRAVITY = Vector(x: 0, y: UI_SCREEN_HEIGHT)

    /// Computed restitution range for more natural physics
    static var UNIVERSAL_RESTITUTION: Double { Double.random(in: 0.7...0.9) }

    /// Universally declared launch force
    static let UNIVERSAL_LAUNCH_FORCE: Double = UI_SCREEN_HEIGHT * 1.5

    /// Universal interval duration for animations etc.
    static let TRANSITION_INTERVAL: TimeInterval = 1.0

    /// Set logging state
    static let LOGGING_IS_ACTIVE = true

    /// Threshold velocity to determine is a ball is stuck
    static let STUCK_VELOCITY_THRESHOLD = 20.0

    /// Threshold duration to activate peg removal
    static let STUCK_DURATION_THRESHOLD = 3.0

    /// CodingKeys enum for a universal coding means
    enum CodingKeys: String, CodingKey {
        case id, centerPositionX, centerPositionY, gameObjectType,
             shapeWidth, shapeHeight, shapeRotation, shapeScale, shapeType
    }

    /// CodingKeys for shape types
    enum ShapeType: String, Codable {
        case circle
        case rectangle
    }

    static let SHAPE_CONSTANTS: [String: (UniversalShape, UniversalShape, Vector, Vector) -> Double?] = [
        ShapeType.circle.rawValue: { this, other, start, end in this.intersects(with: other, at: start, and: end) }
        ]

    /// Universally default circular shape
    static let DEFAULT_CIRCULAR_SHAPE =
    CircularShape(radius: Constants.UNIVERSAL_LENGTH / 2,
                  rotation: 0.0,
                  scale: 1.0)

    /// Universally default rectangular (square) shape
    static let DEFAULT_RECTANGULAR_SHAPE =
    RectangularShape(height: Constants.UNIVERSAL_LENGTH / 2,
                     width: Constants.UNIVERSAL_LENGTH / 2,
                     rotation: 0.0,
                     scale: 1.0)

    /// Given a GeometryProxy, returns a rectangle oriented at the origin
    static func getFullScreen(from geometry: GeometryProxy) -> CGRect {

        let edges = geometry.safeAreaInsets
        let totalWidth = geometry.size.width + edges.leading + edges.trailing
        let totalHeight = geometry.size.height + edges.top + edges.bottom
        let fullSize = CGSize(width: totalWidth, height: totalHeight)

        let gameScreen = CGRect(origin: .zero, size: fullSize)
        return gameScreen
    }

    /// Helper function to calculate distance between two points
    static func distance(from startPoint: CGPoint, to endPoint: CGPoint) -> CGFloat {
        sqrt(pow((endPoint.x - startPoint.x), 2) + pow((endPoint.y - startPoint.y), 2))
    }

}
