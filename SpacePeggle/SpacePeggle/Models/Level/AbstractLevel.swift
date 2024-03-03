import SwiftUI

/// AbstractLevel protocol that Level conforms to, so that AbstractGameEngine
/// (and by corollary, any conforming types) are decoupled from the Level class.
protocol AbstractLevel {
    var name: String { get }
    var gameObjects: [UUID: any GameObject] { get set }

    func getGameObject(id: UUID) -> (any GameObject)?
    func storeGameObject(_ gameObject: any GameObject)
    func updateLevel(_ gameObjects: [UUID: any GameObject])
}
