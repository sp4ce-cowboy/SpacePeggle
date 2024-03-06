import SwiftUI

/// This extension to View adds a conditional modifer to all views.
///
/// This allows for a view to have a modifier applied to it depending on a
/// boolean condition, or return itself otherwise.
///
/// Adapted from https://www.avanderlee.com/swiftui/conditional-view-modifier/
extension View {

    /// Applies the given transform if the given condition evaluates to `true`.
    /// - Parameters:
    ///   - condition: The condition to evaluate.
    ///   - transform: The transform to apply to the source `View`.
    /// - Returns: Either the original `View` or the modified `View` if the condition is `true`.
    @ViewBuilder func `if`<Content: View>(_ condition: @autoclosure () -> Bool,
                                          transform: (Self) -> Content) -> some View {
        if condition() {
            transform(self)
        } else {
            self
        }
    }
}

/// Extensions to allow for a safer retrieval of screen size in the
/// context of SwiftUI where geometry reader might not be available.
///
/// Adapted from
/// 
/// '''
/// https://stackoverflow.com/questions/74458971/
/// correct-way-to-get-the-screen-size-on-ios-after-uiscreen-main-deprecation
/// '''
extension UIWindow {
    static var current: UIWindow? {
        for scene in UIApplication.shared.connectedScenes {
            guard let windowScene = scene as? UIWindowScene else { continue }
            for window in windowScene.windows where window.isKeyWindow {
                    return window
            }
        }
        return nil
    }
}

extension UIScreen {
    static var currentSize: CGSize {
        UIWindow.current?.windowScene?.keyWindow?.bounds.size ??
        UIScreen.main.bounds.size
    }
}

extension Double {
    static var unit: Double { 1.0 }
    var half: Double { self * 0.5 }
    var twice: Double { self * 2.0 }
    var oneHalf: Double { self * 1.5 }
    var square: Double { pow(self, 2) }
    var sqroot: Double { sqrt(self) }
}

extension Int {
    static var unit: Int { 1 }
    static var zero: Int { 0 }
    static var negativeUnit: Int { -1 }
}

extension CGFloat {
    static var unit: Double { Double.unit }
    var half: Double { Double(self).half }
    var twice: Double { Double(self).twice }
    var square: Double { Double(self).square }
    var sqroot: Double { Double(self).sqroot }
}

extension CGPoint {
    var half: CGPoint {
        CGPoint(x: self.x / 2.0, y: self.y / 2.0)
    }

    var unitPoint: UnitPoint {
        UnitPoint(x: Double(self.x), y: Double(self.y))
    }
}

extension CGRect {
    func containsVector(_ vector: Vector) -> Bool {
        self.contains(vector.point)
    }

    func containsAllVectors(_ vectors: [Vector]) -> Bool {
        vectors.allSatisfy { vector in
            self.containsVector(vector)
        }
    }
}

extension CGRect: Shape, @unchecked Sendable {
    public func path(in rect: CGRect) -> Path {
        var path = Path()
        path.addRect(self)
        return path
    }

}

extension Angle: Codable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(self.radians)
    }

    public init(from decoder: Decoder) throws {
        let value = try decoder.singleValueContainer().decode(Double.self)
        self.init(radians: value)
    }
}

extension String {
    mutating func empty() {
        self = ""
    }
}
