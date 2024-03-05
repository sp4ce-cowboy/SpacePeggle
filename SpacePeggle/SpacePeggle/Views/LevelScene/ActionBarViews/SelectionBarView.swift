import SwiftUI

/// View of the Selection bar that contains the different pegs and the delete button.
struct SelectionBarView: View {
    @EnvironmentObject var viewModel: LevelSceneViewModel

    let DIAMETER = Constants.UNIVERSAL_LENGTH * 1.3
    let HALF_OPACITY = 0.3
    let FULL_OPACITY = 1.0

    var body: some View {
        HStack {
            normalPegButton
            goalPegButton
            specialPegButton
            Spacer()
            stubbornPegButton
            blockButton
            Spacer()
            Spacer()
            deleteButton
        }
    }

    // Helper function to determine the image name based on the selected object's type.
    private func buttonImage(for buttonName: Enums.SelectedMode) -> some View {
        let imageName = ObjectSet
            .defaultGameObjectSet[buttonName.rawValue]?.name ?? ObjectSet.DEFAULT_IMAGE_STUB

        return Image(imageName)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: DIAMETER, height: DIAMETER)
    }

    // Helper function to determine the opacity of a button
    private func getOpacity(for button: Enums.SelectedMode) -> Double {
        viewModel.selectedMode == button ? FULL_OPACITY : HALF_OPACITY
    }

    var normalPegButton: some View {
        // Normal Peg (blue)
        Button(action: { viewModel.selectedMode = .NormalPeg },
               label: { buttonImage(for: .NormalPeg) })
        .padding([.leading, .trailing])
        .opacity(getOpacity(for: .NormalPeg))
    }

    var goalPegButton: some View {
        // Goal Peg (orange)
        Button(action: { viewModel.selectedMode = .GoalPeg },
               label: { buttonImage(for: .GoalPeg) })
        .padding([.trailing])
        .opacity(getOpacity(for: .GoalPeg))
    }

    var specialPegButton: some View {
        // Spooky Peg (green)
        Button(action: { viewModel.selectedMode = viewModel.getCurrentSpecialPeg() },
               label: { buttonImage(for: viewModel.getCurrentSpecialPeg()) })
        .padding([.trailing])
        .opacity(getOpacity(for: viewModel.getCurrentSpecialPeg()))
    }

    var spookyPegButton: some View {
        // Spooky Peg (green)
        Button(action: { viewModel.selectedMode = .SpookyPeg },
               label: { buttonImage(for: .SpookyPeg) })
        .padding([.trailing])
        .opacity(getOpacity(for: .SpookyPeg))
    }

    // Either spooky or kaboom depending on game master
    var kaboomPegButton: some View {
        Button(action: { viewModel.selectedMode = .KaboomPeg },
               label: { buttonImage(for: .KaboomPeg) })
        .padding([.trailing])
        .opacity(getOpacity(for: .SpookyPeg))
    }

    var stubbornPegButton: some View {
        // Delete button
        Button(action: { viewModel.selectedMode = .StubbornPeg },
               label: { buttonImage(for: .StubbornPeg) })
        .padding([.trailing])
        .opacity(getOpacity(for: .StubbornPeg))
    }

    var deleteButton: some View {
        // Delete button
        Button(action: { viewModel.selectedMode = .Remove },
               label: { buttonImage(for: .Remove) })
        .padding([.leading, .trailing, .top], 30)
        .opacity(getOpacity(for: .Remove))
        .onLongPressGesture { viewModel.selectedMode = .NormalPeg } // revert on long press
    }

    var blockButton: some View {
        // Delete button
        Button(action: { viewModel.selectedMode = .BlockPeg },
               label: { buttonImage(for: .BlockPeg) })
        .padding([.leading, .trailing])
        .opacity(getOpacity(for: .BlockPeg))
    }

}
