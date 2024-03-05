import SwiftUI
import Foundation

/// Allows game engine the ability to determine and remove stuck balls
extension GameEngine {
    func startCheckingForStuckBall() {
        velocityCheckTimer = Timer.scheduledTimer(
            withTimeInterval: checkInterval, repeats: true) { [weak self] _ in
            self?.checkBallVelocity()
        }
    }

    func checkBallVelocity() {
        let ballVelocity = ball.velocity.magnitude

        if ballVelocity < Constants.STUCK_VELOCITY_THRESHOLD {
            timeBelowThreshold += checkInterval
        } else {
            timeBelowThreshold = 0
        }

        if timeBelowThreshold >= Constants.STUCK_DURATION_THRESHOLD {
            ballIsStuck = true
            velocityCheckTimer?.invalidate()
        } else {
            ballIsStuck = false
        }
    }

    func stopCheckingForStuckBall() {
        velocityCheckTimer?.invalidate()
        timeBelowThreshold = 0
        ballIsStuck = false

    }

    func handleGameObjectRemoval(id: UUID) {
        if ballIsStuck {
            physicsEngine.removeObject(with: id)
            gameObjects.removeValue(forKey: id)
        }
    }

    func handleCollision(withID id: UUID) {
        delegate?.notifyEffect(withId: id)
        if let gameObject = gameObjects[id], !gameObject.isActive {
            gameObjects[id]?.activateGameObject()

            switch gameObject.gameObjectType {
            case .GoalPegActive:
                scores.clearedGoalPegsCount += 1

            case .NormalPegActive:
                scores.clearedNormalPegsCount += 1

            case .SpookyPegActive:
                scores.clearedSpookyPegsCount += 1

            case .KaboomPegActive: // cases covered separately!
                break

            default:
                break
            }
        }
    }
}
