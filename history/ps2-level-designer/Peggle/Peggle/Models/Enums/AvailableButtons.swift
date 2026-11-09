import SwiftUI

/// This enum contains the buttons that are available for selection in the
/// Peg Selection Bar, depending on which images are available
enum AvailableButtons: String {
    case bluePegButton = "peg-blue"
    case orangePegButton = "peg-orange"
    case deleteButton = "delete"

    static var defaultButton: AvailableButtons {
        AvailableButtons.bluePegButton
    }
}
