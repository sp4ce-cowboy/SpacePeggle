import SwiftUI

/// A utility class containing standard methods to generate reusable
/// UI elements across the application.
class StyleSheet {

    static let screenSize: CGSize = Constants.UI_SCREEN_SIZE
    static let screenHeight: Double = screenSize.height
    static let screenWidth: Double = screenSize.width

    static var themeMainColor = Color.black
    static var themeAccentColor = Color.accentColor
    static var themeTextColor = Color.black

    /// A helper function to define a universal size scale.
    ///
    /// Given the required letter-boxing constraint, all sizes will
    /// be scaled according to the width of the current UI screen. For
    /// example, a scaled size of 20% would mean a length that is one-fifth
    /// the width of the screen.
    static func getScaledWidth(_ percent: Double) -> Double {
        screenWidth * (percent / 100)
    }

    /// Similarly, a scaled size of 20% would mean a length that is
    /// one-fifth the height of the screen.
    static func getScaledHeight(_ percent: Double) -> Double {
        screenHeight * (percent / 100)
    }

    static func getRectangleOverlay() -> some View {
        RoundedRectangle(cornerRadius: 80.0)
            .foregroundColor(themeMainColor)
            .padding()
            .frame(width: getScaledWidth(70), height: getScaledHeight(75))
            .opacity(0.9)
    }

    static func getTitleText(text: String) -> some View {
        Text(text)
            .font(.system(size: getScaledWidth(3.5))) // ensures consistent appearance
            .fontDesign(.monospaced)
            .fontWeight(.bold)
            .foregroundStyle(themeTextColor)
    }

    /// A function that returns a scaled rectangle with some text
    /// in it.
    static func getRectangleWithText(text: String) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 25)
                .padding()
                .frame(width: getScaledWidth(55),
                       height: getScaledHeight(12))
                .contentShape(RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/))
                .overlay {
                    getTitleText(text: text)
                        .frame(width: getScaledWidth(50))
                }
        }
    }

    /// A function that returns a scaled rectangular button with some
    /// text and an action.
    static func getRectangleButtonWithAction(text: String,
                                             action: @escaping () -> Void) -> some View {
        Button(action: { action() },
               label: { getRectangleWithText(text: text) })
    }
}
