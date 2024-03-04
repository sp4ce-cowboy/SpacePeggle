import SwiftUI

/// Global enums class, to ensure all enums are organized at a single
/// source of truth point.
class Enums {

    /// CodingKeys enum coding game objects
    enum GameObjectCodingKeys: String, CodingKey {
        case id
        case center
        case gameObjectType
        case shapeType
        case shapeWidth
        case shapeHeight
        case shapeRotation
        case shapeScale
    }

    enum LevelCodingKeys: String, CodingKey {
        case name, gameObjects
    }

    /// CodingKeys for shape types
    enum ShapeType: String, Codable {
        case circle
        case rectangle
    }

    /// Indicator for Selection bar
    enum SelectedMode: String, Codable {
        case NormalPeg
        case GoalPeg
        case BlockPeg
        case SpookyPeg
        case KaboomPeg
        case StubbonPeg
        case Remove
    }

    enum GameObjectType: String, Codable {
        case NormalPeg, NormalPegActive
        case GoalPeg, GoalPegActive
        case BlockPeg
        case SpookyPeg, SpookyPegActive
        case KaboomPeg, KaboomPegActive
        case StubbornPeg
    }
}
