import SwiftUI

/// An enum that encapsulates all available Peg Colors.
///
/// This enum exists because all Pegs are represented with their corresponding images,
/// and having this enum as the intemediary ensures that invalid colors are not passed
/// as raw strings.
enum PegColor: String {
    case blue
    case orange

    static var defaultColor: PegColor {
        PegColor.blue
    }
}
