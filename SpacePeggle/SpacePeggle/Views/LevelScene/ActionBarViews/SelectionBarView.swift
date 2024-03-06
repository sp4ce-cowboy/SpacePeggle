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
               label: {
            ZStack {
                viewModel.buttonImage(for: .NormalPeg)
                Text("\(viewModel.getNormalPegCount())")
                    .font(.largeTitle)
                    .foregroundColor(.black)
            }
        })
        .padding([.leading, .trailing])
        .opacity(viewModel.getOpacity(for: .NormalPeg))
    }

    var goalPegButton: some View {
        // Goal Peg (orange)
        Button(action: { viewModel.selectedMode = .GoalPeg },
               label: {
            ZStack {
                viewModel.buttonImage(for: .GoalPeg)
                Text("\(viewModel.getGoalPegCount())")
                    .font(.largeTitle)
                    .foregroundColor(.black)
            }
        })
        .padding([.trailing])
        .opacity(viewModel.getOpacity(for: .GoalPeg))
    }

    // Either spooky or kaboom depending on game master
    var specialPegButton: some View {
        Button(action: { viewModel.selectedMode = viewModel.getCurrentSpecialPeg() },
               label: {
            ZStack {
                viewModel.buttonImage(for: viewModel.getCurrentSpecialPeg())
                Text("\(viewModel.getSpecialPegCount())")
                    .font(.largeTitle)
                    .foregroundColor(.black)
            }
        })
        .padding([.trailing])
        .opacity(viewModel.getOpacity(for: viewModel.getCurrentSpecialPeg()))
    }

    var spookyPegButton: some View {
        Button(action: { viewModel.selectedMode = .SpookyPeg },
               label: {
            ZStack {
                viewModel.buttonImage(for: .SpookyPeg)
                Text("\(viewModel.getSpookyPegCount())")
                    .font(.largeTitle)
                    .foregroundColor(.black)
            }
        })
        .padding([.trailing])
        .opacity(viewModel.getOpacity(for: .SpookyPeg))
    }

    var kaboomPegButton: some View {
        Button(action: { viewModel.selectedMode = .KaboomPeg },
               label: {
            ZStack {
                viewModel.buttonImage(for: .KaboomPeg)
                Text("\(viewModel.getKaboomPegCount())")
                    .font(.largeTitle)
                    .foregroundColor(.black)
            }
        })
        .padding([.trailing])
        .opacity(viewModel.getOpacity(for: .KaboomPeg))
    }

    var stubbornPegButton: some View {
        Button(action: { viewModel.selectedMode = .StubbornPeg },
               label: {
            ZStack {
                viewModel.buttonImage(for: .StubbornPeg)
                Text("\(viewModel.getStubbornPegCount())")
                    .font(.largeTitle)
                    .foregroundColor(.black)
            }
        })
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
               label: {
            ZStack {
                viewModel.buttonImage(for: .BlockPeg)
                Text("\(viewModel.getBlockCount())")
                    .font(.largeTitle)
                    .foregroundColor(.white)
            }
        })
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
        .disabled(viewModel.isButtonDisabled())
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
        .disabled(viewModel.isButtonDisabled())
    }

}
