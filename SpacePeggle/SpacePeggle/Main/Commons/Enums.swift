import SwiftUI

/// Global enums class, to ensure all enums are organized at a single
/// source of truth point.
class Enums {

    /// CodingKeys enum for a universal coding means
    enum CodingKeys: String, CodingKey {
        case id, centerPositionX, centerPositionY, gameObjectType,
             shapeWidth, shapeHeight, shapeRotation, shapeScale, shapeType
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
}
