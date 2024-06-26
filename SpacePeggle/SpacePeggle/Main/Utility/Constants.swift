import SwiftUI

/// A universal source of truth and control for certain application wide configurations
/// and properties. Also includes some universal utility methods.
public class Constants {

    static var SOUND_EFFECTS_ENABLED = true

    /// Set logging state
    static let LOGGING_IS_ACTIVE = false

    /// Universally declared screen size
    static var UI_SCREEN_SIZE: CGSize = UIScreen.currentSize

    /// Universally declared screen width
    static var UI_SCREEN_WIDTH: Double { UI_SCREEN_SIZE.width }

    /// Universally declared screen height
    static var UI_SCREEN_HEIGHT: Double { UI_SCREEN_SIZE.height }

    /// Universal background image
    static var BACKGROUND_IMAGE: Enums.BackgroundImages = .Space

    /// Universal background audio
    static var BACKGROUND_AUDIO: String = "field-of-memories-soundtrack.mp3"

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

    /// Universally declared launch force as a proportion of screen width to ensure consistency
    static let UNIVERSAL_LAUNCH_FORCE: Double = UI_SCREEN_WIDTH

    /// Ball mass
    static let UNIVERSAL_BALL_MASS: Double = 100

    /// Allows for mass scaling with radius
    static let STUBBORN_PEG_DENSITY: Double = UNIVERSAL_BALL_MASS * 5

    /// Universally declared power up state
    static var UNIVERSAL_POWER_UP: Enums.PowerUp = .Spooky

    /// Explosion strength for kaboom pegs
    static var UNIVERSAL_EXPLOSION_STRENGTH: Double = 5

    /// Universal interval duration for animations etc.
    static let TRANSITION_INTERVAL: TimeInterval = .unit

    /// Threshold velocity to determine is a ball is stuck
    static let STUCK_VELOCITY_THRESHOLD = 20.0

    /// Threshold duration to activate peg removal
    static let STUCK_DURATION_THRESHOLD = 3.0

    /// The minimum movement required to register a drag gesture
    static let MOVEMENT_THRESHOLD: CGFloat = 1.0

    /// The threshold for which a given score difference can be considered a combo
    static var SCORE_COMBO_THRESHOLD: Int = 10_000

    /// MAX HP VALUE
    static var MAX_HP_VALUE: Int = 10
    static var MIN_HP_VALUE: Int = 1

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
    /// Regardless of the screen size, the origin of the game area will be adjusted
    /// by a points in the positive y-direction where a is a ratio of the launcher
    /// size, determined by the screen. This is to accomodate the launcher's
    /// minimum size, and some added buffer space so that game objects do not get
    /// in the way of the user's ability to aim and launch the cannon.
    ///
    /// Furthermore, the offset ensures that both the selection bar is fully
    /// visible below the game area. This requires trial and error with different
    /// iPad sizes, "1.1" seems to be the most universal fit.
    static func getAdjustedGameArea() -> CGRect {
        let width = UI_SCREEN_WIDTH
        let height = UI_SCREEN_WIDTH
        let size = CGSize(width: width, height: height)
        let origin = Vector(x: 0, y: UNIVERSAL_LAUNCHER_HEIGHT * 1.1).point
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
