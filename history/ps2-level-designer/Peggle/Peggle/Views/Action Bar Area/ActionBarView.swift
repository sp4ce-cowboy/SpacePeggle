import SwiftUI

/// View of the action bar at the bottom that the user can interact with.
/// Having this class allows the entire bottom section of the Level designer to
/// be uniformly modifiable.
struct ActionBarView: View {
    @Binding var isRemove: Bool
    @Binding var color: PegColor
    @Binding var pegs: [Peg]
    @Binding var levelNameInput: String

    var width: CGFloat
    var height: CGFloat
    var adjustedHeight: CGFloat {
        height * Utility.BOTTOM_HEIGHT_MODIFER
    }

    var body: some View {
        VStack(spacing: 0) {
            PegSelectionBarView(isRemove: $isRemove, color: $color)
            FunctionBarView(levelNameInput: $levelNameInput, pegs: $pegs)
        }
        .frame(maxHeight: adjustedHeight)
        .frame(width: width, height: adjustedHeight)
        .background(Color.white)
    }
}
