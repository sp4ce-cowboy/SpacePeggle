import SwiftUI
import Foundation

/// The UniversalObject protocol contains an identifier, and
/// a UniversalShape.
protocol UniversalObject: Identifiable {
    var id: UUID { get }
    var centerPosition: Vector { get set }
    var shape: any UniversalShape { get set }
}
