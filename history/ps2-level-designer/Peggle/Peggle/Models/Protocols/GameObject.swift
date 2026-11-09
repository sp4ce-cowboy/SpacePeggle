import SwiftUI

/// A protocol whose conforming types must implement the id property
/// of type UUID.
///
/// All objects in the game must conform to the GameObject protocol, which conforms to the
/// `Identifiable` protocol and specifies `UUID` as the required `ObjectIdentifer`.
/// This ensures that all objects in the game can be uniquely identified without having
/// to rely on other attributes which might not be entirely reliable for uniqueness
/// assurance.
protocol GameObject: Identifiable {
    var id: UUID { get }
}
