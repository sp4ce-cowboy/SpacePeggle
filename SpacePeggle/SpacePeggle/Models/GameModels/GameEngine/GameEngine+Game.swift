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

    func resetBall() {
        stopCheckingForStuckBall()
        physicsObjects.removeValue(forKey: ball.id)
        ball = Ball()
    }

    func updateGameState() {
        delegate?.transferScores(scores: scores, state: ballIsOutOfBounds)

        /// Perform victory check
        if !isBallLaunched && scores.availableBallCount == 0 {
            delegate?.transferScores(scores: scores, state: true)
            delegate?.triggerLoss()
            return
        }

        /// Handle game objects that stray away from game scene
        handleGameObjectsOutOfBoundary()

        /// Facilitate ball explosion
        handleExplodingObjects()

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

        self.delegate?.transferScores(scores: scores, state: ballIsOutOfBounds)
    }

    func processActiveGameObjects() {
        for (id, _) in gameObjects {
            guard let gameObject = gameObjects[id], gameObject.isActive else {
                continue
            }

            /// Expansion for type-specific logic
            switch gameObject.gameObjectType {
            case .SpookyPegActive:
                physicsEngine.isDomainExpansionActive = false
                scores.status.empty()
            default:
                break
            }

            delegate?.removeActiveGameObjects(withId: id)

            // Object needs to be removed from the physics object
            // storage to ensure that it does not get resusciated from
            // the game-physics engine synchronization-loop
            physicsEngine.removeObject(with: id)
            gameObjects.removeValue(forKey: id)
        }
    }

    func handleExplodingObjects() {
        let explodingObjects = gameObjects.values.filter { $0.gameObjectType == .KaboomPegActive }

        if !explodingObjects.isEmpty {
            scores.status = "Explosion Alert!"
            explodingObjects.forEach { explodingObject in
                /// 0. Determine explosion radius of eR = 4R (i.e. 4x Diameter)
                let explosionShape = CircularShape(diameter: explodingObject.height * 4)
                let explosionObject = KaboomPeg(centerPosition: explodingObject.centerPosition,
                                                shape: explosionShape)

                /// 1. Activate all objects in explosion radius
                /// Objects will be activated on the smallest of overlap
                let affectedObjects = gameObjects.values.filter { affectedObject in
                    if explosionObject.overlap(with: affectedObject) != nil,
                       affectedObject.id != explodingObject.id {
                        return true
                    }
                    return false
                }

                affectedObjects.forEach { $0.activateGameObject() }

                /// 2. Delegate velocity application on game ball separately since game ball belongs to
                /// the game engine but operates at the physics layer. But Delegate application to
                /// physics engine to maintain SRP.
                physicsEngine.applySpecialPhysicsOn(objectId: ball.id,
                                                    at: explosionObject.centerPosition,
                                                    for: explosionObject.height.half)

                /// 3. Delegate physics application for all applicable game objects
                affectedObjects.forEach { affectedPhysicsObject in
                    Logger.log("Affected physics objects are \(affectedObjects)")
                    if let physicsObject = affectedPhysicsObject as? (any PhysicsObject) {
                        Logger.log("Affected physics single object is \(physicsObject)")
                        physicsEngine.applySpecialPhysicsOn(objectId: physicsObject.id,
                                                            at: explosionObject.centerPosition,
                                                            for: explosionObject.height.half)
                    }
                }

                /// 4. Call delegate to process animation, delegate will callback to
                /// process game object removal, separating each layer.

                self.delegate?.processSpecialGameObjects(withId: explodingObject.id)
                self.scores.status = ""
                self.scores.clearedKaboomPegsCount += 1

            }
        }
    }

    func handleGameObjectsOutOfBoundary() {
        gameObjects.values      // if nil, return false. If false, return false. If true return true.
            .filter { physicsEngine.isNotWithinDomain(point: $0.centerPosition) ?? false ? true : false }
            .forEach { self.handleObjectRemoval(id: $0.id) }
    }

    func handleObjectRemoval(id: UUID) {
        physicsEngine.removeObject(with: id)
        gameObjects.removeValue(forKey: id)
    }
}
