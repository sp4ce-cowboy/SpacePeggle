import SwiftUI

/// View of the ScoreBoard that contains game information
struct ScoreBoardView: View {
    @EnvironmentObject var viewModel: GameSceneViewModel

    var scores: ScoreBoard { viewModel.scores }
    let DIAMETER = Constants.UNIVERSAL_LENGTH * 1.3

    var body: some View {
        ZStack {
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    goalPegCount
                    specialPegCount
                    availableBallCount
                    Spacer()
                    status
                    Spacer()
                    scoreCount
                    Spacer()
                }
                .padding()
                .frame(maxHeight: Constants.getAdjustedActionBarHeight.half)
                .frame(width: Constants.UI_SCREEN_WIDTH,
                       height: Constants.getAdjustedActionBarHeight.half,
                       alignment: .bottom)
                .background {
                    Color
                        .white
                        .opacity(0.9)
                        .blur(radius: 2.0)
                }
            }
        }
    }

    // Helper function to determine the image name based on the selected object's type.
    private func buttonImage(for buttonName: String) -> some View {
        let imageName = ObjectSet
            .defaultGameObjectSet[buttonName]?.name ?? ObjectSet.DEFAULT_IMAGE_STUB

        return Image(imageName)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: DIAMETER, height: DIAMETER)
    }

    var goalPegCount: some View {
        ZStack {
            buttonImage(for: "GoalPeg")
                .padding()

            Text("\(scores.remainingGoalPegsCount)")
                .font(.largeTitle)
                .foregroundColor(.black)
        }
    }

    var normalPegCount: some View {
        ZStack {
            buttonImage(for: "NormalPeg")
                .padding()

            Text("\(scores.remainingNormalPegsCount)")
                .font(.largeTitle)
                .foregroundColor(.black)
        }
    }

    var specialPegCount: some View {
        ZStack {
            buttonImage(for: viewModel.handleGetCurrentPowerUpImage())
                .padding()

            Text("\(scores.remainingSpecialPegsCount)")
                .font(.largeTitle)
                .foregroundColor(.black)
        }
    }

    var spookyPegCount: some View {
        ZStack {
            buttonImage(for: "SpookyPeg")
                .padding()

            Text("\(scores.remainingSpookyPegsCount)")
                .font(.largeTitle)
                .foregroundColor(.black)
        }
    }

    var kaboomPegCount: some View {
        ZStack {
            buttonImage(for: "KaboomPeg")
                .padding()

            Text("\(scores.remainingKaboomPegsCount)")
                .font(.largeTitle)
                .foregroundColor(.black)
        }
    }

    var availableBallCount: some View {
        ZStack {
            buttonImage(for: "Ball")
                .padding()

            Text("\(scores.availableBallCount)")
                .font(.largeTitle)
                .foregroundColor(.black)
        }
    }

    var scoreCount: some View {
        Text("\(scores.currentScore)")
            .font(.title)
            .foregroundColor(.blue)
    }

    var status: some View {
        Text("\(scores.status)")
            .font(.title)
            .foregroundColor(.black)
    }
}
