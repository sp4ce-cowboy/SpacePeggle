import SwiftUI

/// View of the Peg selection bar that contains the different pegs and the delete button.
struct PegSelectionBarView: View {
    let DIAMETER = Utility.PEG_SELECTION_BAR_DIAMETER
    let HALF_OPACITY = 0.5
    let FULL_OPACITY = 1.0

    @Binding var isRemove: Bool
    @Binding var color: PegColor
    @State var currentlyActiveButton = AvailableButtons.defaultButton

    var body: some View {
        HStack {
            // Blue Peg
            Button(action: {
                isRemove = false
                color = PegColor.blue
                currentlyActiveButton = .bluePegButton
            }, label: {
                buttonImage(for: .bluePegButton)
            })
            .padding([.leading, .trailing, .top])
            .opacity(getOpacity(for: .bluePegButton))

            // Orange Peg
            Button(action: {
                isRemove = false
                color = PegColor.orange
                currentlyActiveButton = .orangePegButton
            }, label: {
                buttonImage(for: .orangePegButton)
            })
            .padding([.trailing, .top])
            .opacity(getOpacity(for: .orangePegButton))

            // To separate the Pegs from the Delete button
            Spacer()

            // Delete button
            Button(action: {
                isRemove = true
                currentlyActiveButton = .deleteButton
            }, label: {
                buttonImage(for: .deleteButton)
            })
            .padding([.leading, .trailing, .top])
            .opacity(getOpacity(for: .deleteButton))

        }
        .background(Color.white)
    }

    /// Helper function to determine the image name based on the peg's color.
    /// Given an input AvailableButton Type, the name of the image file corresponding
    /// to that type is retrieved. 
    private func buttonImage(for button: AvailableButtons) -> some View {
        Image(button.rawValue)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: DIAMETER, height: DIAMETER)
    }

    /// Helper function to determine the opacity of a button
    private func getOpacity(for button: AvailableButtons) -> Double {
        currentlyActiveButton == button ? FULL_OPACITY : HALF_OPACITY
    }
}
