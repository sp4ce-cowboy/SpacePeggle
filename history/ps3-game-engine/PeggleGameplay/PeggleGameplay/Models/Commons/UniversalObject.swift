import SwiftUI
import Foundation

/// The UniversalObject protocol assigns a centerposition and a
/// Unique identifier for all objects in the game. It is the equivalent
/// of a Node, as it also contains the centerPosition.
///
/// Note that this excludes any level-specific imagery, such as
/// background and ball launcher.
///
/// Initially named PeggleObject, but changed to UniversalObject since
/// this protocol is the parent of PhysicsObject and having a UUID and
/// centerPosition doesn't make this a peggle specific construct, since
/// it can be used outside of Peggle. Tl;dr "UniversalObject" has is more
/// semantically valid than "PeggleObject".
protocol UniversalObject: Identifiable {
    var id: UUID { get } // id is a get only property ensuring constant id throughout
                         // the object's lifecycle
    var centerPosition: Vector { get set }

}
