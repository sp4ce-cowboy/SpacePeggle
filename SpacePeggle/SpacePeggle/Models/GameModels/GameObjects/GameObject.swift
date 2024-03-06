import SwiftUI

/// The GameObject class provides a standard interface between
/// a level model and standard game objects, to act as a default implementation.
///
/// All GameObjects have an initial center point, and can be encoded and decoded.
///
/// GameObjects specifically refer to those Objects in game that need to be loaded
/// and stored from file. Thus, they conform to the Codable protocol and
///
/// It is important to note that as of the current implementation, GameObject
/// semantically refers to object contained in a Level i.e. specifically those
/// objects that can be coded as part of a Level. Thus, it excludes objects that
/// are present in the game but not stored to file for e.g. Ball or Launcher.
/// A more referentially accurate name would be LevelObject, however, given that
/// Level itself is a construct, and this construct may morph in the future (maybe
/// Levels become a subset or superset of another sub-level or super-level like "Stage")
/// LevelObjects as they are interpreted are formally referred to as "GameObjects".
protocol GameObject: UniversalObject, Codable {
    var gameObjectType: Enums.GameObjectType { get set }
    var isActive: Bool { get set }
    var shape: UniversalShape { get set }
    var hp: Int { get set }

    func activateGameObject()
    init(centerPosition: Vector, id: UUID,
         gameObjectType: Enums.GameObjectType, shape: UniversalShape, hp: Int)

    /// GameObjects overlap while PhysicsObjects collide, both of which
    /// are determined by UniversalShapes that intersect.
    func overlap(with object: any GameObject) -> Double?
}

/// This extension adds default collision resolution measures to game objects
extension GameObject {
    func overlap(with object: any GameObject) -> Double? {
        self.shape.intersects(with: object.shape, at: self.centerPosition,
                              and: object.centerPosition)
    }
}
