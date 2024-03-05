import SwiftUI

/// A class to keep track of game scores and conditions
struct ScoreBoard {
    var ballEntersBucketCount: Int = 0
    var currentGoalPegsCount: Int = 0
    var currentTotalPegsCount: Int = 0
    var clearedGoalPegsCount: Int = 0
    var totalBallCount: Int = 5
    var shotBallCount: Int = 0
    var availableBallCount: Int {
        totalBallCount - shotBallCount
    }

    var currentScore: Int {
        clearedGoalPegsCount * 100 + (ballEntersBucketCount * 1_000)
    }
}
