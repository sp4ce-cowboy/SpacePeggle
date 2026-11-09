/// 
/// A universal source of truth and control for certain application wide configurations
/// and properties. Also includes some universal utility methods
///
import SwiftUI

public class Utility {

    /// Universally declared peg diameter to force all pegs to be the same size
    public static let UNIVERSAL_PEG_DIAMETER: CGFloat = 40

    /// Size of the peg buttons on the peg selection bar
    public static let PEG_SELECTION_BAR_DIAMETER: CGFloat = 60

    /// The name of the folder used to store the levels locally
    public static let STORAGE_CONTAINER_NAME: String = "Levels"

    /// The minimum movement required to register a drag gesture
    public static let MOVEMENT_THRESHOLD: CGFloat = 1.0

    /// Height modifiers are used to ensure an optimal ratio between the gameplay
    /// area and the Action Bar Area.
    public static let TOP_HEIGHT_MODIFIER: Double = 0.85
    public static let BOTTOM_HEIGHT_MODIFER: Double = 1 - TOP_HEIGHT_MODIFIER

    // A universal helper function to dismiss the keyboard from anywhere
    public static func dismissKeyboard() {
        UIApplication.shared.sendAction(#selector(
            UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }

}
