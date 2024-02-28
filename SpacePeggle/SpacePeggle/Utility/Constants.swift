import SwiftUI

/// A universal source of truth and control for certain application wide configurations
/// and properties. Also includes some universal utility methods.
public class Constants {
    /// Universally declared Geometry
    static var geometry: GeometryProxy?

    /// Universally declared object diameter
    static let UNIVERSAL_LENGTH: CGFloat = UIScreen.main.bounds.size.height / 25

    /// Universally declared unit mass
    static let UNIT_MASS: Double = 1.0

    /// Universally declared velocity cut-off
    static let VELOCITY_CUTOFF: Double = 20.0

    /// Universally declared gravitational field strength
    static var UNIVERSAL_GRAVITY = Vector(x: 0, y: 981)

    /// Universally declared restitution
    static let UNIVERSAL_RESTITUTION: Double = 0.8

    /// Universally declared launch force
    static let UNIVERSAL_LAUNCH_FORCE: Double = 1_000

    /// Universally declared screen size
    static let UI_SCREEN_SIZE: CGSize = UIScreen.main.bounds.size

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
        case id, centerPositionX, centerPositionY, gameObjectType
    }

    /// Given a GeometryProxy, returns a rectangle oriented at the origin
    static func getGameScreen(from geometry: GeometryProxy) -> CGRect {
        let absoluteWidth = geometry.size.width
        let absoluteHeight = geometry.size.height

        let gameScreen = CGRect(origin: .zero,
                                size: CGSize(width: absoluteWidth, height: absoluteHeight))
        return gameScreen
    }

    /// Helper function to calculate distance between two points
    static func distance(from startPoint: CGPoint, to endPoint: CGPoint) -> CGFloat {
        sqrt(pow((endPoint.x - startPoint.x), 2) + pow((endPoint.y - startPoint.y), 2))
    }

    /// Helper function to generate a unit of length equivalent to a fraction of
    /// the sizes pro

}
