import SwiftUI

/// View of the Selection bar that contains the different pegs and the delete button.
struct SelectionBarView: View {
    @EnvironmentObject var viewModel: LevelSceneViewModel

    let DIAMETER = Constants.UNIVERSAL_LENGTH * 1.3

    var body: some View {
        HStack {
            normalPegButton
            goalPegButton
            specialPegButton
            stubbornPegButton
            blockButton
            Spacer()
            Spacer()
            getIncrementButton
            getDecrementButton
            deleteButton
        }
    }

    var normalPegButton: some View {
        // Normal Peg (blue)
        Button(action: { viewModel.selectedMode = .NormalPeg },
               label: { viewModel.buttonImage(for: .NormalPeg) })
        .padding([.leading, .trailing])
        .opacity(viewModel.getOpacity(for: .NormalPeg))
    }

    var goalPegButton: some View {
        // Goal Peg (orange)
        Button(action: { viewModel.selectedMode = .GoalPeg },
               label: { viewModel.buttonImage(for: .GoalPeg) })
        .padding([.trailing])
        .opacity(viewModel.getOpacity(for: .GoalPeg))
    }

    // Either spooky or kaboom depending on game master
    var specialPegButton: some View {
        Button(action: { viewModel.selectedMode = viewModel.getCurrentSpecialPeg() },
               label: { viewModel.buttonImage(for: viewModel.getCurrentSpecialPeg()) })
        .padding([.trailing])
        .opacity(viewModel.getOpacity(for: viewModel.getCurrentSpecialPeg()))
    }

    var spookyPegButton: some View {
        Button(action: { viewModel.selectedMode = .SpookyPeg },
               label: { viewModel.buttonImage(for: .SpookyPeg) })
        .padding([.trailing])
        .opacity(viewModel.getOpacity(for: .SpookyPeg))
    }

    var kaboomPegButton: some View {
        Button(action: { viewModel.selectedMode = .KaboomPeg },
               label: { viewModel.buttonImage(for: .KaboomPeg) })
        .padding([.trailing])
        .opacity(viewModel.getOpacity(for: .SpookyPeg))
    }

    var stubbornPegButton: some View {
        Button(action: { viewModel.selectedMode = .StubbornPeg },
               label: { viewModel.buttonImage(for: .StubbornPeg) })
        .padding([.trailing])
        .opacity(viewModel.getOpacity(for: .StubbornPeg))
    }

    var deleteButton: some View {
        // Delete button
        Button(action: { viewModel.selectedMode = .Remove },
               label: { viewModel.buttonImage(for: .Remove) })
        .padding([.leading, .trailing], 30)
        .opacity(viewModel.getOpacity(for: .Remove))
    }

    var blockButton: some View {
        Button(action: { viewModel.selectedMode = .BlockPeg },
               label: { viewModel.buttonImage(for: .BlockPeg) })
        .padding([.leading, .trailing])
        .opacity(viewModel.getOpacity(for: .BlockPeg))
    }

    var getIncrementButton: some View {
        Button(action: { viewModel.handleIncrement() },
               label: { Image(systemName: "plus.circle")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: DIAMETER, height: DIAMETER)
                .foregroundStyle(Color.green)})
        .padding([.leading, .trailing])
        .opacity(viewModel.getHpOpacity())
    }

    var getDecrementButton: some View {
        Button(action: { viewModel.handleDecrement() },
               label: { Image(systemName: "minus.circle")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: DIAMETER, height: DIAMETER)
                .foregroundStyle(Color.red)})
        .padding([.leading, .trailing])
        .opacity(viewModel.getHpOpacity())
    }

}
