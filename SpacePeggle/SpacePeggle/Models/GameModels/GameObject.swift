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
    var gameObjectType: String { get set }
    var isActive: Bool { get set }
    func activateGameObject()
    init(centerPosition: Vector, id: UUID, gameObjectType: String)
}

/// This provides a default implementation for a GameObject to be coded and decoded
extension GameObject {

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Constants.CodingKeys.self)
        let id = try container.decode(UUID.self, forKey: .id)
        let x = try container.decode(Double.self, forKey: .centerPositionX)
        let y = try container.decode(Double.self, forKey: .centerPositionY)
        let type = try container.decode(String.self, forKey: .gameObjectType)

        self.init(centerPosition: Vector(x: x, y: y), id: id, gameObjectType: type)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: Constants.CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(centerPosition.x, forKey: .centerPositionX)
        try container.encode(centerPosition.y, forKey: .centerPositionY)
        try container.encode(gameObjectType, forKey: .gameObjectType)
    }

}
