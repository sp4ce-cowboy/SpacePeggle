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
    var ballIsOutofBounds: Bool { currentBallPosition.y > physicsEngine.domain.height }

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
        }

    }

    func updateGameState() {
        if bucket.containsObject(ball) {
            Logger.log("bucket contains ball!")
            self.resetBall()
        }

        if ballIsOutofBounds {
            self.isBallLaunched = false
            self.resetBall()
            DispatchQueue.main.asyncAfter(deadline: .now() + Constants.TRANSITION_INTERVAL) {
                self.removeActiveGameObjects()
            }
        }
    }

    func resetBall() {
        stopCheckingForStuckBall()
        physicsObjects.removeValue(forKey: ball.id)
        ball = Ball()
    }

    func removeActiveGameObjects() {
        for (id, _) in gameObjects {
            guard let gameObject = gameObjects[id], gameObject.isActive else {
                continue
            }
            delegate?.processActiveGameObjects(withID: id)

            // Object needs to be removed from the physics object
            // storage to ensure that it does not get resusciated from
            // the game-physics engine synchronization-loop
            physicsObjects.removeValue(forKey: id)
            gameObjects.removeValue(forKey: id)

        }
    }
}
