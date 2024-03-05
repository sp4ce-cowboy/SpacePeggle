import SwiftUI

/// A class to keep track of game scores and conditions
struct ScoreBoard {
    var ballEntersBucketCount: Int = 0

    var totalGoalPegsCount: Int = 0
    var clearedGoalPegsCount: Int = 0
    var remainingGoalPegsCount: Int {
        totalGoalPegsCount - clearedGoalPegsCount
    }

    var totalNormalPegsCount: Int = 0
    var clearedNormalPegsCount: Int = 0
    var remainingNormalPegsCount: Int {
        totalNormalPegsCount - clearedNormalPegsCount
    }

    var totalBallCount: Int = 2
    var shotBallCount: Int = 0
    var availableBallCount: Int {
        totalBallCount - shotBallCount
    }

    var currentScore: Int {
        clearedGoalPegsCount * 1_000 + (ballEntersBucketCount * 10_000)
    }

    var getWinState: Bool {
        remainingGoalPegsCount == 0
    }

    var getLoseState: Bool {
        availableBallCount < 0 && remainingGoalPegsCount > 0
    }
}
