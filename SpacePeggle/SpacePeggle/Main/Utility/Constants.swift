import SwiftUI

/// A universal source of truth and control for certain application wide configurations
/// and properties. Also includes some universal utility methods.
public class Constants {

    /// Universally declared screen size
    static var UI_SCREEN_SIZE: CGSize = UIScreen.currentSize

    /// Universally declared screen width
    static var UI_SCREEN_WIDTH: Double { UI_SCREEN_SIZE.width }

    /// Universally declared screen height
    static var UI_SCREEN_HEIGHT: Double { UI_SCREEN_SIZE.height }

    /// Universal background image
    static var BACKGROUND_IMAGE: Enums.BackgroundImages = .Space

    /// The name of the folder used to store the levels locally
    public static let STORAGE_CONTAINER_NAME: String = "Levels"

    /// Universally declared object diameter. Scaled to a certain appropriate
    /// length based on the most optimal visual appearance of objects in game.
    static let UNIVERSAL_LENGTH: Double = UI_SCREEN_SIZE.width / 18.0

    /// Adjusted launcher height ensures that the launcher will always be
    /// of a minimum size so that drag gestures work properly.
    static var UNIVERSAL_LAUNCHER_HEIGHT: Double { max(90.0, StyleSheet.getScaledWidth(10)) }

    /// Universally declared unit mass
    static let UNIT_MASS: Double = .unit

    /// Universally declared velocity cut-off for removing stuck ball after launch
    static let VELOCITY_CUTOFF: Double = 20.0

    /// Universally declared gravitational field strength
    static var UNIVERSAL_GRAVITY = Vector(x: .zero, y: 1_000)

    /// Computed restitution range for more natural physics
    static var UNIVERSAL_RESTITUTION: Double { Double.random(in: 0.7...0.9) }

    /// Universally declared launch force
    static let UNIVERSAL_LAUNCH_FORCE: Double = UI_SCREEN_HEIGHT

    /// Universally declared power up state
    static var UNIVERSAL_POWER_UP: Enums.PowerUp = .Spooky

    /// Universal interval duration for animations etc.
    static let TRANSITION_INTERVAL: TimeInterval = .unit

    /// Set logging state
    static let LOGGING_IS_ACTIVE = true

    /// Threshold velocity to determine is a ball is stuck
    static let STUCK_VELOCITY_THRESHOLD = 20.0

    /// Threshold duration to activate peg removal
    static let STUCK_DURATION_THRESHOLD = 3.0

    /// The minimum movement required to register a drag gesture
    static let MOVEMENT_THRESHOLD: CGFloat = 1.0

    /*
    static let SHAPE_CONSTANTS: [String: (UniversalShape, UniversalShape, Vector, Vector) -> Double?] = [
        Enums.ShapeType.circle.rawValue: { this, other, 
     start, end in this.intersects(with: other, at: start, and: end) }
        ]
     */

    // A universal helper function to dismiss the keyboard from anywhere
    public static func dismissKeyboard() {
        UIApplication.shared.sendAction(#selector(
            UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }

    /// Universally default circular shape
    static let DEFAULT_CIRCULAR_SHAPE =
    CircularShape(diameter: Constants.UNIVERSAL_LENGTH,
                  rotation: .zero,
                  scale: .unit)

    /// Universally default rectangular (square) shape
    static let DEFAULT_RECTANGULAR_SHAPE =
    RectangularShape(height: Constants.UNIVERSAL_LENGTH,
                     width: Constants.UNIVERSAL_LENGTH,
                     rotation: .zero,
                     scale: .unit)

    /// Given a GeometryProxy, returns a rectangle oriented at the origin
    static func getFullScreen(from geometry: GeometryProxy) -> CGRect {
        let edges = geometry.safeAreaInsets
        let totalWidth = geometry.size.width + edges.leading + edges.trailing
        let totalHeight = geometry.size.height + edges.top + edges.bottom
        let fullSize = CGSize(width: totalWidth, height: totalHeight)

        let gameScreen = CGRect(origin: .zero, size: fullSize)
        return gameScreen
    }

    static func getFullScreenWithSafeEdges(from geometry: GeometryProxy) -> CGRect {
        let totalWidth = geometry.size.width
        let totalHeight = geometry.size.height
        let fullSize = CGSize(width: totalWidth, height: totalHeight)

        let gameScreen = CGRect(origin: .zero, size: fullSize)
        return gameScreen
    }

    static func getDefaultFullScreen() -> CGRect {
        let fullSize = CGSize(width: UI_SCREEN_WIDTH, height: UI_SCREEN_HEIGHT)
        return CGRect(origin: .zero, size: fullSize)
    }

    /// Returns a customized letterboxed GameScreen that can work on all
    /// iPad screen sizes. iPad screen ratios range from 4:3 (1.33) to
    /// the newer 1.44. This means that the new iPads are about 8% taller, and
    /// accomodating to the width would ensure that all iPads fit.
    ///
    /// The game area will essentially be a square that the user can interact with.
    /// Regardless of the screen size, the start of the game area will be adjusted
    /// by x points in the positive y-direction where x is a ratio of the launcher
    /// size, determined by the screen. This is to accomodate the launcher's
    /// minimum size, and some added buffer space so that game objects do not get
    /// in the way of the user's ability to aim and launch the cannon.
    static func getAdjustedGameArea() -> CGRect {
        let width = UI_SCREEN_WIDTH
        let height = UI_SCREEN_WIDTH
        let size = CGSize(width: width, height: height)
        let origin = Vector(x: 0, y: UNIVERSAL_LAUNCHER_HEIGHT * 1.2).point
        return CGRect(origin: origin, size: size)
    }

    /// Returns the width remaining after accounting for adjustment for GameArea.
    static let getAdjustedActionBarHeight: Double =
    UI_SCREEN_HEIGHT - (UI_SCREEN_WIDTH + StyleSheet.getScaledHeight(10))

    /// Helper function to calculate distance between two points
    static func distance(from startPoint: CGPoint, to endPoint: CGPoint) -> Double {
        Double(sqrt(pow((endPoint.x - startPoint.x), 2) + pow((endPoint.y - startPoint.y), 2)))
    }

}
