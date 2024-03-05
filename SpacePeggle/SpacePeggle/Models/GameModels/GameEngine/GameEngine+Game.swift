import SwiftUI

/// This extension adds core game functions to the Game Engine,
/// such as setting the launcher, launching the ball, and resetting the
/// stage if the ball were to go out of bounds.
///
/// It also adds the ability to reset the ball, and invoke the animation
/// to make pegs disappear.
extension GameEngine {

    var currentBallPosition: Vector { ball.centerPosition }
    var currentBallShape: UniversalShape { ball.shape }
    var ballIsOutOfBounds: Bool { currentBallPosition.y > physicsEngine.domain.height }

    func addPhysicsObject(object: any PhysicsObject) {
        Logger.log("added \(object)")
        physicsEngine.addPhysicsObject(object: object)
    }

    func updateLauncherRotation(with dragValue: DragGesture.Value, for size: CGSize) {
        launcher.updateRotation(with: dragValue, for: size)
    }

    func launchBall() {
        if !isBallLaunched {
            ball.velocity = launcher.launchVelocityVector
            ball.centerPosition = launcher.launcherTipPosition
            self.addPhysicsObject(object: self.ball)
            self.startCheckingForStuckBall()
            self.isBallLaunched = true
            self.scores.shotBallCount += 1
            updateGameState()
        }
    }

    func updateGameState() {

        /// Perform score check
        if !isBallLaunched && scores.availableBallCount == 0 {
            delegate?.transferScores(scores: scores)
            delegate?.triggerLoss()
            return
        }

        /// Facilitate ball explosion
        if gameObjects.values.contains(where: { $0.gameObjectType == .KaboomPegActive }) {
            delegate?.processSpecialGameObjects()
        }

        /// Facilitate domain expansion ability
        if gameObjects.values.contains(where: { $0.gameObjectType == .SpookyPegActive }) {
            scores.status = "Domain Expansion!"
            physicsEngine.isDomainExpansionActive = true
        }

        /// Facilitate ball reset
        if ballIsOutOfBounds || bucket.containsObject(ball) {
            if bucket.containsObject(ball) {
                delegate?.notifySpecialEffect()
                self.scores.ballEntersBucketCount += 1
                self.scores.totalBallCount += 1
                Logger.log("bucket contains ball!", self)
                physicsEngine.isDomainExpansionActive = false
            }

            self.isBallLaunched = false
            self.resetBall()
            // DispatchQueue.main.asyncAfter(deadline: .now() + Constants.TRANSITION_INTERVAL) {
            self.processActiveGameObjects()
        }

        self.delegate?.transferScores(scores: scores)
    }

    func resetBall() {
        stopCheckingForStuckBall()
        physicsObjects.removeValue(forKey: ball.id)
        ball = Ball()
    }

    func processActiveGameObjects() {
        for (id, _) in gameObjects {
            guard let gameObject = gameObjects[id], gameObject.isActive else {
                continue
            }

            Logger.log("Game object is \(gameObject)", self)
            Logger.log("Game object type is \(gameObject.gameObjectType)")

            switch gameObject.gameObjectType {
            case .GoalPeg, .GoalPegActive:
                scores.clearedGoalPegsCount += 1

            case .NormalPeg, .NormalPegActive:
                scores.clearedNormalPegsCount += 1

            case .SpookyPeg, .SpookyPegActive:
                scores.clearedSpookyPegsCount += 1
                physicsEngine.isDomainExpansionActive = false
                scores.status.empty()

            case .KaboomPeg, .KaboomPegActive:
                scores.clearedKaboomPegsCount += 1
                scores.status = "Explosion Alert!"
                delegate?.processSpecialGameObjects()

            case .StubbornPeg:
                break

            case .BlockPeg:
                break
            }

            delegate?.removeActiveGameObjects(withId: id)

            // Object needs to be removed from the physics object
            // storage to ensure that it does not get resusciated from
            // the game-physics engine synchronization-loop
            physicsEngine.removeObject(with: id)
            gameObjects.removeValue(forKey: id)
        }

        /*if !isBallLaunched &&
            scores.availableBallCount == 0 &&
            scores.remainingGoalPegsCount > 0 {
            delegate?.triggerLoss()
        }*/
    }

    func handleObjectRemoval(id: UUID) {
        physicsEngine.removeObject(with: id)
        gameObjects.removeValue(forKey: id)
    }
}
