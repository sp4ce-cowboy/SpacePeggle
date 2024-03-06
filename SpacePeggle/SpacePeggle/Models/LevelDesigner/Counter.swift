import SwiftUI

/// A custom struct for the level designer to relay information about its level objects
/// without having to expose the level objects directly.
struct Counter {
    var normalPegCount: Int = 0
    var goalPegCount: Int = 0
    var spookyPegCount: Int = 0
    var kaboomPegCount: Int = 0
    var blockCount: Int = 0
    var stubbornPegCount: Int = 0
}
