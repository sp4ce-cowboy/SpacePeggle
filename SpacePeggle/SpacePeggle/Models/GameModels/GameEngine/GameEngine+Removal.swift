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
}
