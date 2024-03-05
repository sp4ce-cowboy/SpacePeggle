import SwiftUI

/// A class to keep track of game scores and conditions
struct ScoreBoard {
    var powerUp: Enums.PowerUp = Constants.UNIVERSAL_POWER_UP
    var ballEntersBucketCount: Int = 0

    var status: String = ""

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

    var totalSpookyPegsCount: Int = 0
    var clearedSpookyPegsCount: Int = 0
    var remainingSpookyPegsCount: Int {
        totalSpookyPegsCount - clearedSpookyPegsCount
    }

    var totalKaboomPegsCount: Int = 0
    var clearedKaboomPegsCount: Int = 0
    var remainingKaboomPegsCount: Int {
        totalKaboomPegsCount - clearedKaboomPegsCount
    }

    var totalSpecialPegsCount: Int {
        switch powerUp {
        case .Kaboom:
            totalKaboomPegsCount
        case .Spooky:
            totalSpookyPegsCount
        }
    }

    var clearedSpecialPegsCount: Int {
        switch powerUp {
        case .Kaboom:
            clearedKaboomPegsCount
        case .Spooky:
            clearedSpookyPegsCount
        }
    }

    var remainingSpecialPegsCount: Int {
        switch powerUp {
        case .Kaboom:
            remainingKaboomPegsCount
        case .Spooky:
            remainingSpookyPegsCount
        }
    }

    var totalBallCount: Int = 5
    var shotBallCount: Int = 0
    var availableBallCount: Int {
        totalBallCount - shotBallCount
    }

    var currentScore: Int {
        clearedGoalPegsCount * 2_000 + (ballEntersBucketCount * 10_000)
        + clearedSpookyPegsCount * 1_000 + clearedKaboomPegsCount * 1_000
        + clearedNormalPegsCount * 500
    }

    var getWinState: Bool {
        remainingGoalPegsCount == 0
    }

    var getLoseState: Bool {
        availableBallCount < 0 && remainingGoalPegsCount > 0
    }
}
