import SwiftUI

/// A View of a Peg
struct PegView: View {
    var peg: Peg
    static let DIAMETER: CGFloat = Utility.UNIVERSAL_PEG_DIAMETER

    var body: some View {
        Image(pegImageName(for: peg.color))
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: PegView.DIAMETER, height: PegView.DIAMETER)
            .position(peg.centerPosition)
    }

    /// Determine the image name based on the peg's color
    private func pegImageName(for color: PegColor.RawValue) -> String {
        switch color {
        case PegColor.blue.rawValue:
            return AvailableButtons.bluePegButton.rawValue
        case PegColor.orange.rawValue:
            return AvailableButtons.orangePegButton.rawValue
        default:
            return AvailableButtons.defaultButton.rawValue
        }
    }
}
