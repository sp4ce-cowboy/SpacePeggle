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
        case shape
        case hp
    }

    enum LevelCodingKeys: String, CodingKey {
        case name
        case gameObjects
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
        case StubbornPeg
        case Remove
    }

    enum GameObjectType: String, Codable, CodingKey {
        case NormalPeg, NormalPegActive
        case GoalPeg, GoalPegActive
        case BlockPeg
        case SpookyPeg, SpookyPegActive
        case KaboomPeg, KaboomPegActive
        case StubbornPeg
    }

    enum PhysicsObjectType: String {
        case Ball
        case Launcher
        case Bucket
        case NormalPeg, NormalPegActive
        case GoalPeg, GoalPegActive
        case BlockPeg
        case SpookyPeg, SpookyPegActive
        case KaboomPeg, KaboomPegActive
        case StubbornPeg
    }

    enum MenuState {
        case MainMenu
        case LevelSelectionMenu
        case SettingsMenu
        case PowerUpMenu
        case EnvironmentMenu
    }

    enum BackgroundImages: String {
        case Space = "space-background"
        case Mars = "mars-background"
        case Earth = "background"
        case Saturn = "saturn-background"
    }

    enum AppScene: String {
        case StartScene
        case LevelScene
        case GameScene
    }

    enum PowerUp: String {
        case Spooky = "SpookyPeg"
        case Kaboom = "KaboomPeg"
    }
}
