import SwiftUI
import Foundation

class Peg: GameObject, PhysicsObject {

    /// See Ball.swift
    static let PEG_RADIUS =
    Double(ObjectSet
        .defaultPhysicsObjectSet["DefaultPeg"]?.size.width ?? CGFloat(Constants.UNIVERSAL_LENGTH)) / 2

    var id: UUID
    var centerPosition: Vector
    var rotation: Angle = .degrees(0)
    var magnification: Double = 1.0

    var mass: Double = .infinity
    var velocity: Vector = .zero
    var force: Vector = .zero
    var shape: PhysicsShape

    var gameObjectType: String
    var isActive = false

    /// Initializer for Peg as a GameObject
    required init(centerPosition: Vector, id: UUID = UUID(),
                  gameObjectType: String = "DefaultPeg") {
        self.centerPosition = centerPosition
        self.id = id
        self.gameObjectType = gameObjectType
        self.mass = .infinity
        self.velocity = .zero
        self.shape = CircleShape(center: centerPosition, radius: Peg.PEG_RADIUS)
    }

    /// Initializer for Peg as a PhysicsObject
    required init(mass: Double, velocity: Vector,
                  centerPosition: Vector, force: Vector, id: UUID = UUID()) {
        self.mass = .infinity
        self.velocity = velocity
        self.force = force
        self.centerPosition = centerPosition
        self.id = id
        self.gameObjectType = "DefaultPeg"
        self.shape = CircleShape(center: centerPosition, radius: Peg.PEG_RADIUS)

    }

    func activateGameObject() {
        isActive = true
    }

}
