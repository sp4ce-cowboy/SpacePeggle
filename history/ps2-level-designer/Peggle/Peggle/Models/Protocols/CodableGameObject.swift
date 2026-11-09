import SwiftUI

/// This protocol ensures that all conforming types which involve
/// file operations implement both the UUID required by GameObject
/// and the encoding/decoding functionality specified by Codable
protocol CodableGameObject: Codable, GameObject {

}
